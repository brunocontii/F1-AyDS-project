require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'

set :database_file, './config/database.yml'
set :public_folder, File.dirname(__FILE__) + '/public'

require './models/user'
require './models/profile'
require './models/gamemode'
require './models/free'
require './models/progressive'
require './models/answer'
require './models/reply'
require './models/buy'
require './models/wildcard'
require './models/option'
require './models/question'

enable :sessions

class App < Sinatra::Application
    # para asegurarse de que toda la inicialización necesaria en las clases se realice correctamente
    def initialize(app = nil)
        super()
    end

    # para limpiar la cache 
    before do
        cache_control :no_cache, :no_store, :must_revalidate
        expires 0, :public, :no_cache

        if session[:username]
            current_user = User.find_by(username: session[:username])
            current_user.regenerate_life_if_needed if current_user
        end
    end

    before do
        # apenas entras se pueden a estas 5 rutas nada mas.
        pass if request.path_info == '/' || request.path_info == '/login' || request.path_info == '/register' || request.path_info == '/how-to-play' || request.path_info == '/team'
        # pedirigir al inicio si no hay usuario en la sesión , ni gamemodes ni progressive nada xq hay siempre un usuario en la sesion
        redirect '/' unless session[:username]
      end

    # pagina apenas entras a la app
    get '/' do
        erb :'home/home'
    end

    # get de logueo
    get '/login' do
        erb :'login/login'
    end

    # post para loguearse que pedimos el usuario y contraseña
    post '/login' do
        username = params[:username]
        password = params[:password]
        # buscamos el usuario y contraseña en la base de datos
        user = User.find_by(username: username, password: password)
        # si existe va derecho a gamemodes
        if user
            session[:username] = user.username # Guardar el nombre de usuario en la sesión
            redirect "/gamemodes"
        else # escribiste mal algo o no existe el usuario o no estas logueado (es mas generico)
            @error = "Invalid username or password. Please try again."
            erb :'login/login'
        end
    end
    # VER SI LO SACAMOS
    # era para ver cuales guardabamos nomas.
    get '/users' do
        @users = User.all
        erb :'users/users'
    end
    # 
    get '/register' do
        erb :'register/register'
    end

    # registrar un usuario
    post '/register' do
        username = params[:username]
        password = params[:password]
        rpassword = params[:repeat_password]

        if User.where(username: username).exists?
            @error = "Username already exist"
            erb :'register/register'
        elsif password != rpassword
            @error = "Passwords are different"
            erb :'register/register'
        else # si el usuario no estaba cargado y las contraseñas son iguales se crea un usuario, con 3 vidas y 0 monedas
            user = User.create(username: username, password: password, cant_life: 3 , cant_coins: 0)
            session[:username] = user.username
            redirect '/gamemodes' # redirecciona a jugar
        end

    end

    # ver para que sirve 
    get '/logout' do
        session.clear
        redirect '/'
    end

    # como jugar 
    get '/how-to-play' do
        erb :'how-to-play/howToPlay'
    end

    get '/profile' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        
        # recupero el usuario y traigo el perfil a @profile
        @profile = @current_user.profile

        if @profile.nil? # si no existe crea uno,
            erb :'profiles/newProfile', locals: { user: @current_user }
        else 
            @profile = @current_user.profile if @current_user
            erb :'profiles/profile', locals: { profile: @profile }
        end      
        
    end

    post '/newProfile' do
        name = params[:name]
        lastname = params[:lastname]
        description = params[:description]
        age = params[:age]

        @current_user = User.find_by(username: session[:username]) if session[:username]
        profile = Profile.create(name: name, lastName: lastname, description: description, age: age, user_id: @current_user.id)
        redirect '/profile' # redirecciona a jugar

    end

    get '/gamemodes' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        if request.xhr? # solicitud AJAX , permite que solo traiga las vidas, sin recargar toda la pagina.
            content_type :json # respuesta json y se convierte en cadena y va a buscar las vidas del usuario en sesion.
            { lives: @current_user.cant_life }.to_json
        else
            erb :'gamemodes/gamemodes', locals: { current_user: @current_user }
        end
    end

    get '/gamemodes/progressive' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        erb :'progressives/progressives' , locals: { current_user: @current_user }
    end

    # generalizacion de las rutas del modo de juego progresivo
    # se crean las rutas de manera dinamica para cada tema del modo progresivo
    ['pilot', 'team', 'career', 'circuit'].each do |mode|
        get "/gamemodes/progressive/#{mode}" do
            handle_progressive_mode_request(mode)
        end

        post "/gamemodes/progressive/#{mode}" do
            handle_progressive_mode_submission(mode)
        end
    end

    # metodo para manejar la solicitud GET de un tema del modo progresivo
    def handle_progressive_mode_request(mode)
        # obtenemos el usuario actual de la sesion
        @current_user = User.find_by(username: session[:username]) if session[:username]

        # verificamos si tiene vidas para jugar
        unless @current_user&.can_play?
            session[:message] = "You have 0 lives. Please wait for lives to regenerate."
            session[:color] = "red"
            redirect '/gamemodes'
            return
        end

        session[:answered_questions] ||= []
        answered_by_user_ids = Answer.where(user_id: @current_user.id).pluck(:question_id)

        # seleccionamos una pregunta relacionada al tema seleccionado por el usuario,
        # que no haya sido respondida todavia
        @question = Question.where(theme: mode).where.not(id: session[:answered_questions] + answered_by_user_ids).order('RANDOM()').first 

        if @question.nil?
            session[:message] = "¡Felicidades, termino esta tematica!"
            session[:color] = "green"
            redirect '/gamemodes'
        end

        @options = @question.options

        feedback_message = session.delete(:message)
        feedback_color = session.delete(:color)
        @form_action = "/gamemodes/progressive/#{mode}"

        erb :'questions/questions', locals: { current_user: @current_user, question: @question, options: @options, feedback_message: feedback_message, feedback_color: feedback_color }
    end

    # metodo para manejar la solicitud POST de un tema del modo progresivo
    def handle_progressive_mode_submission(mode)
        # obtenemos el usuario actual de la sesion
        @current_user = User.find_by(username: session[:username]) if session[:username]

        if params[:timeout] == 'true'
            # cuando se acabo el tiempo para responder una pregunta
            @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
            # si al acabarse el tiempo se queda sin vidas
            if @current_user.cant_life == 0
                session[:message] = "You have 0 lives. Please wait for lives to regenerate."
                session[:color] = "red"
                redirect '/gamemodes'
                return
            else
                # sino sigue respondiendo preguntas
                session[:message] = "Time's up! Incorrect!"
                session[:color] = "red"
            end
        else
            # si logra responder antes de que se le acaba el tiempo
            @option = Option.find(params[:option_id].to_i)
            # aprovechamos la relacion de questions y options
            @question = @option.question

            # si la respuesta es correcta gana monedas
            if @option.correct
                Answer.create(question_id: @question.id, user_id: @current_user.id, option_id: @option.id)
                @current_user.increment!(:cant_coins, 10)
                session[:message] = "Correct! Well done."
                session[:color] = "green"
            else
                # sino pierde vidas
                @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
                if @current_user.cant_life == 0
                    session[:message] = "You have 0 lives. Please wait for lives to regenerate."
                    session[:color] = "red"
                    redirect '/gamemodes'
                    return
                else
                    session[:message] = "Incorrect!"
                    session[:color] = "red"
                end
            end
    
            session[:answered_questions] ||= []
            session[:answered_questions] << @question.id
        end

        redirect "/gamemodes/progressive/#{mode}"
    end

    # Modo Free
    get '/gamemodes/free' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
    
        unless @current_user&.can_play?
            session[:message] = "You have 0 lives. Please wait for loves to regenerate."
            session[:color] = "red"
            redirect '/gamemodes'
            return
        end
    
        session[:answered_free_questions] ||= []
        session[:free_mode_difficulty] ||= 'easy'

        @question = Question.where(level: session[:free_mode_difficulty])
                            .where.not(id: session[:answered_free_questions])
                            .order('RANDOM()')
                            .first

        if @question.nil?
        case session[:free_mode_difficulty]
            when 'easy'
                session[:free_mode_difficulty] = 'normal'
                session[:message] = "You've answered all the easy questions. Now the medium questions will appear."
            when 'medium'
                session[:free_mode_difficulty] = 'hard'
                session[:message] = "You've answered all the medium questions. Now the hard questions will appear."
            when 'hard'
                session[:free_mode_difficulty] = 'impossible'
                session[:message] = "You've answered all the hard questions. Now the impossible questions will appear."
            when 'impossible'
                session[:free_mode_difficulty] = nil
                session[:answered_free_questions] = []
                session[:message] = "Congratulations! You've completed the Free Mode."
                redirect '/gamemodes'
                return
            end
            redirect '/gamemodes/free'
            return
        end

        @options = @question.options.shuffle
        feedback_message = session.delete(:message)
        feedback_color = session.delete(:color)
        @form_action = '/gamemodes/free'

        erb :'questions/questions', locals: { current_user: @current_user, question: @question, options: @options, feedback_message: feedback_message, feedback_color: feedback_color }
    end

    post '/gamemodes/free' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        @option = Option.find(params[:option_id].to_i)
        @question = @option.question

        if @option.correct
            @current_user.increment!(:cant_coins, 10)
            session[:message] = "Correct! Well done."
            session[:color] = "green"
        else
            @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
            if @current_user.cant_life == 0
                session[:message] = "Yo have 0 lives. Please wait for loves to regenerate."
                session[:color] = "red"
                redirect '/gamemodes'
                return
            else
            session[:message] = "Incorrect!"
            session[:color] = "red"
            end
        session[:message] = "Incorrect!"
        session[:color] = "red"
        end

        session[:answered_free_questions] ||= []
        session[:answered_free_questions] << @question.id

        redirect '/gamemodes/free'
    end

end
