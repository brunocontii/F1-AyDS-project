require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'bcrypt'

set :database_file, './config/database.yml'
set :public_folder, File.dirname(__FILE__) + '/public'

require './models/user'
require './models/profile'
require './models/gamemode'
require './models/answer'
require './models/option'
require './models/question'

enable :sessions

class App < Sinatra::Application
    $racha = 1
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
        # redirigir al inicio si no hay usuario en la sesión , ni gamemodes ni progressive nada xq hay siempre un usuario en la sesion.
        redirect '/' unless session[:username]
    end

    # pagina apenas entras a la app.
    get '/' do
        erb :'home/home'
    end

    # get de logueo.
    get '/login' do
        erb :'login/login'
    end

    # post para loguearse que pedimos el usuario y contraseña.
    post '/login' do
        username = params[:username]
        password = params[:password]
        # buscamos el usuario y contraseña en la base de datos
        user = User.find_by(username: username)
        # si existe va derecho a gamemodes
        if user && user.authenticate(password)
            session[:username] = user.username # Guardar el nombre de usuario en la sesión
            redirect "/gamemodes"
        else # escribiste mal algo o no existe el usuario o no estas logueado (es mas generico)
            @error = "Invalid username or password."
            erb :'login/login'
        end
    end

    # get de registro para mostrar el formulario.
    get '/register' do
        # lista de todas las fotos que se encuentran dentro de public/profile_pictures
        @profile_pictures = Dir.glob("public/profile_pictures/*").map{ |path| path.split('/').last }
        erb :'register/register'
    end

    # registrar un usuario
    post '/register' do
        username = params[:username]
        password = params[:password]
        rpassword = params[:repeat_password]
        name = params[:name]
        lastname = params[:lastname]
        email = params[:email]
        description = params[:description]
        age = params[:age]
        profile_picture = params[:profile_pic]
        @profile_pictures = Dir.glob("public/profile_pictures/*").map{ |path| path.split('/').last }

        if User.where(username: username).exists?
            @error = "Username already exist"
            erb :'register/register'
        elsif password != rpassword
            @error = "Passwords are different"
            erb :'register/register'
        else # si el usuario no estaba cargado y las contraseñas son iguales se crea un usuario, con 3 vidas y 0 monedas
            user = User.new(username: username, password: password, cant_life: 3, cant_coins: 0, total_points: 0)
            # Intentamos guardar el usuario y verificamos si se guardo correctamente
            if user.save
                Profile.create(name: name, lastName: lastname, email: email, description: description, age: age, user: user, profile_picture: profile_picture)
                session[:username] = user.username
                redirect '/gamemodes'    
            else
                @error = "Failed to create the account. Please try again."
                erb :'register/register'
            end
        end
    end

    get '/logout' do
        session.clear
        redirect '/'
    end

    # como jugar
    get '/how-to-play' do
        erb :'how-to-play/howToPlay'
    end

    # Team
    get '/team' do
        erb :'team/team'
    end

    get '/profile' do
        @current_user = User.find_by(username: session[:username]) if session[:username]

        if request.xhr?
            content_type :json
            {lives: @current_user.cant_life}.to_json
        else
            # recupero el usuario y traigo el perfil a @profile
            @profile = @current_user.profile
            @profile = @current_user.profile if @current_user
            @countPi = Question.where(theme: 'pilot').count > 0 ? Answer.where(user_id: @current_user.id).joins(:question).where(questions: { theme: 'pilot' }).count*100/Question.where(theme: 'pilot').count : 0
            @countCi = Question.where(theme: 'circuit').count > 0 ? Answer.where(user_id: @current_user.id).joins(:question).where(questions: { theme: 'circuit' }).count*100/Question.where(theme: 'circuit').count : 0
            @countCa = Question.where(theme: 'career').count > 0 ? Answer.where(user_id: @current_user.id).joins(:question).where(questions: { theme: 'career' }).count*100/Question.where(theme: 'career').count : 0
            @countTe = Question.where(theme: 'team').count > 0 ? Answer.where(user_id: @current_user.id).joins(:question).where(questions: { theme: 'team' }).count*100/Question.where(theme: 'team').count : 0
            @countTotal = Question.count > 0 ? (Answer.where(user_id: @current_user.id).count*100)/Question.count : 0
            erb :'profiles/profile', locals: { profile: @profile, countPi: @countPi, countCi: @countCi, countCa: @countCa, countTe: @countTe, countTotal: @countTotal }
        end
    end

    post '/profile/picture' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        if @current_user
            @profile = @current_user.profile
            @profile.update(profile_picture: params[:profile_picture])
        end
        redirect '/profile'
    end

    get '/profile/change-password' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        @profile = @current_user.profile
        erb :'profiles/change-pass', locals: { profile: @profile}
    end

    post '/profile/change_password' do
        @current_user = User.find_by(username: session[:username]) if session[:username]

        if @current_user
            current_password = params[:current_password]
            new_password = params[:new_password]
            confirm_password = params[:confirm_password]

            # Verificar si la contraseña actual coincide
            if @current_user.authenticate(current_password)
                # Verificar si la nueva contraseña coincide con la confirmación
                if new_password == confirm_password
                    # Actualizar la contraseña
                    @current_user.update(password: new_password)
                    flash[:success] = "Password changed successfully."
                    redirect '/profile'
                else
                    flash[:error] = "The new passwords do not match."
                    redirect '/profile/change-password'
                end
            else
                flash[:error] = "The current password is incorrect."
                redirect '/profile/change-password'
            end
        else
            flash[:error] = "User not found."
            redirect '/profile/change-password'
        end
    end

    get '/gamemodes' do
        # Intenta obtener los 10 usuarios con más puntos en orden descendente
        @users = User.order(total_points: :desc).limit(10) || []
        # Si hay una sesión activa, busca el usuario actual
        @current_user = User.find_by(username: session[:username]) if session[:username]

        if request.xhr? # Si la solicitud es AJAX, envía solo los datos necesarios
            content_type :json
            { lives: @current_user&.cant_life || 0 }.to_json # Maneja el caso en que @current_user pueda ser nil
        else
            # Renderiza la vista con los usuarios y el usuario actual como variables locales
            erb :'gamemodes/gamemodes', locals: { current_user: @current_user, users: @users }
        end
    end

    get '/gamemodes/progressive' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        if request.xhr?
            content_type :json
            {lives: @current_user.cant_life}.to_json
        else
            erb :'progressives/progressives' , locals: { current_user: @current_user }
        end
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
        end

        session[:answered_questions] ||= []
        answered_by_user_ids = Answer.where(user_id: @current_user.id).pluck(:question_id)

        # seleccionamos una pregunta relacionada al tema seleccionado por el usuario,
        # que no haya sido respondida todavia
        @question = Question.where(theme: mode).where.not(id: answered_by_user_ids).order('RANDOM()').first

        if @question.nil?
            session[:message] = "¡Congratulations, you finished this theme!"
            session[:color] = "green"
            redirect '/gamemodes'
        end

        # ordenamos las opciones de manera random
        @options = @question.options.to_a.shuffle

        feedback_message = session.delete(:message)
        feedback_color = session.delete(:color)
        @form_action = "/gamemodes/progressive/#{mode}"

        erb :'questions/questions', locals: { current_user: @current_user, question: @question, options: @options, feedback_message: feedback_message, feedback_color: feedback_color }
    end

    def handle_progressive_mode_submission(mode)
        @current_user = User.find_by(username: session[:username]) if session[:username]

        unless @current_user&.can_play?
            session[:message] = "You have 0 lives. Please wait for lives to regenerate."
            session[:color] = "red"
            return redirect '/gamemodes'
        end

        if params[:timeout] == 'true' && !session[:inmunity]
            handle_timeout
        else
            handle_option_submission
        end

        redirect "/gamemodes/progressive/#{mode}"
    end

    private

    def handle_timeout
        @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
        if @current_user.cant_life.zero?
            session[:message] = "You have 0 lives. Please wait for lives to regenerate."
            session[:color] = "red"
            redirect '/gamemodes'
        else
            session[:message] = "Time's up! Incorrect!"
            session[:color] = "red"
        end
    end

    def handle_option_submission
        if params[:option_id].to_i > 0
            @option = Option.find(params[:option_id].to_i)
            @question = @option.question
            if @option.correct
                Answer.create(question_id: @question.id, user_id: @current_user.id, option_id: @option.id)
                @current_user.increment!(:cant_coins, 10)
                @current_user.increment!(:total_points, 50*$racha)
                $racha = $racha + 1
                session[:message] = "Correct! Well done."
                session[:color] = "green"
            elsif session[:inmunity]
                session[:inmunity] = false
                session[:message] = "Activate inmunity"
                session[:color] = "green"
            else
                handle_incorrect_answer
            end
            session[:answered_questions] ||= []
            session[:answered_questions] << @question.id
        elsif session[:inmunity]
            session[:inmunity] = false
            session[:message] = "Activate inmunity"
            session[:color] = "green"
        else
            session[:message] = "Invalid option ID"
            session[:color] = "red"
            redirect '/gamemodes'
        end
    end

    def handle_incorrect_answer
        $racha = 1
        @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
        if @current_user.cant_life.zero?
            session[:message] = "You have 0 lives. Please wait for lives to regenerate."
            session[:color] = "red"
            redirect '/gamemodes'
        else
            session[:message] = "Incorrect!"
            session[:color] = "red"
        end
    end


    post '/use_extra_time' do
        # Obtenemos la solicitud y convertimos el JSON recibido en un hash
        content_type :json
        request_body = request.body.read
        params = JSON.parse(request_body)

        # Extraemos al usuario desde los parametros y lo buscamos
        user_id = params['user_id']
        @current_user = User.find(user_id)

        # Caso donde el usuario SI puede comprar el comodin
        if @current_user&.cant_coins.to_i >= 75
            @current_user.update!(cant_coins: @current_user.cant_coins - 75)
            # Devolvemos un JSON con el estado exitoso
            { status: 'success' }.to_json
        else
            # Devolvemos un JSON con un mensaje de error
            { status: 'error', message: 'Not enough coins' }.to_json
        end
    end

    post '/use_50_50' do
        # Obtenemos la solicitud y convertimos el JSON recibido en un hash
        content_type :json
        request_body = request.body.read
        params = JSON.parse(request_body)

        # Extraemos al usuario desde los parametros y lo buscamos
        user_id = params['user_id']
        @current_user = User.find(user_id)
        # Estraemos la pregunta desde los parametros y la buscamos
        # Tambien buscamos las opciones para esa pregunta
        question_id = params['question_id']
        question = Question.find(question_id)
        options = question.options

        # Caso donde el usuario SI puede comprar el comodin
        if @current_user.cant_coins >= 150
            @current_user.update(cant_coins: @current_user.cant_coins - 150)

            # Seleccionar 2 opciones incorrectas al azar
            incorrect_options = options.reject { |option| option.correct }.sample(2)
            incorrect_option_ids = incorrect_options.map(&:id)

            # Devolvemos un JSON con el estado exitoso
            { status: 'success', removed_options: incorrect_option_ids }.to_json
        else
            # Devolvemos un JSON con un mensaje de error
            { status: 'error', message: 'Not enough coins' }.to_json
        end
    end

    post '/inmunity' do
        # Obtenemos la solicitud y convertimos el JSON recibido en un hash
        content_type :json
        request_body = request.body.read
        params = JSON.parse(request_body)

        # Extraemos al usuario desde los parametros y lo buscamos
        user_id = params['user_id']
        @current_user = User.find(user_id)

        # Caso donde el usuario SI puede comprar el comodin
        if @current_user&.cant_coins.to_i >= 200
            session[:inmunity] = true
            @current_user.update!(cant_coins: @current_user.cant_coins - 200)
            # Devolvemos un JSON con el estado exitoso
            { status: 'success' }.to_json
        else
            # Devolvemos un JSON con un mensaje de error
            { status: 'error', message: 'Not enough coins' }.to_json
        end
    end

    # Modo Free
    get '/gamemodes/free' do
        @current_user = User.find_by(username: session[:username]) if session[:username]

        # Reinicia el modo de juego si el usuario vuelve a ingresar
        if session[:reset_free_mode]
            session[:reset_free_mode] = false
            free_answers = Answer.joins(:question).where(questions: { theme: 'free' })

            # Restar las respuestas del modo "free" de la tabla completa de respuestas
            Answer.where(id: free_answers.pluck(:id)).destroy_all
        end

        unless @current_user&.can_play?
            session[:message] = "You have 0 lives. Please wait for lives to regenerate."
            session[:color] = "red"
            redirect '/gamemodes'
        end

        session[:answered_free_questions] ||= []
        session[:free_mode_difficulty] ||= 'easy'
        answered_by_user_ids = Answer.where(user_id: @current_user.id).pluck(:question_id)
        # Preguntas que aún no han sido respondidas en esta dificultad
        unanswered_questions = Question.where(level: session[:free_mode_difficulty], theme: 'free')
                                    .where.not(id: answered_by_user_ids)
                                    .order('RANDOM()')

        # Preguntas incorrectamente respondidas (no en las respuestas correctas)
        incorrectly_answered_questions = Question.where(level: session[:free_mode_difficulty], theme: 'free')
                                            .where.not(id: answered_by_user_ids)
                                            .where(id: session[:answered_free_questions])
                                            .order('RANDOM()')

        # Seleccionar la siguiente pregunta
        if unanswered_questions.exists?
            @question = unanswered_questions.first
        elsif incorrectly_answered_questions.exists?
            @question = incorrectly_answered_questions.first
        else
            @question = Question.where(level: session[:free_mode_difficulty])
                                .order('RANDOM()').first
        case session[:free_mode_difficulty]
        when 'easy'
            session[:free_mode_difficulty] = 'normal'
            session[:message] = "You've answered all the easy questions. Now the medium questions will appear."
        when 'normal'
            session[:free_mode_difficulty] = 'difficult'
            session[:message] = "You've answered all the medium questions. Now the hard questions will appear."
        when 'difficult'
            session[:free_mode_difficulty] = 'impossible'
            session[:message] = "You've answered all the hard questions. Now the impossible questions will appear."
        when 'impossible'
            session[:free_mode_difficulty] = 'easy'
            session[:answered_free_questions] = []
            session[:message] = "Congratulations! You've completed the Free Mode."
            session[:reset_free_mode] = true
            all_questions = Question.all

            if all_questions.exists?
                @question = all_questions.order('RANDOM()').first
            end
            redirect '/gamemodes'
        end
        redirect '/gamemodes/free'
        end

        @options = @question.options.shuffle
        feedback_message = session.delete(:message)
        feedback_color = session.delete(:color)
        @form_action = '/gamemodes/free'

        erb :'questions/questions', locals: { current_user: @current_user, question: @question, options: @options, feedback_message: feedback_message, feedback_color: feedback_color }
    end

    post '/gamemodes/free' do
        # Buscamos al usuario
        @current_user = User.find_by(username: session[:username]) if session[:username]

        # Verificamos que el usuario pueda jugar
        unless @current_user&.can_play?
            session[:message] = "You have 0 lives. Please wait for lives to regenerate."
            session[:color] = "red"
            return redirect '/gamemodes'
        end

        # Si se acabo el tiempo para responder y no tiene activada la inmunidad
        if params[:timeout] == 'true' && !session[:inmunity]
            # Metodo que maneja la expiracion del tiempo
            handle_free_timeout
        else
            # Si no se agoto el tiempo, o tiene inmunidad, llamamos al metodo que maneja
            # la opcion seleccionada
            handle_free_option_submission
        end

        redirect '/gamemodes/free'
    end

    private

    # Metodo que maneja lo que pasa cuando el tiempo para responder se acaba
    def handle_free_timeout
        # Restamos 1 vida al usuario
        @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
        # Verificamos si el usuario puede seguir jugando o no
        if @current_user.cant_life.zero?
            session[:message] = "You have 0 lives. Please wait for lives to regenerate."
            session[:color] = "red"
            redirect '/gamemodes'
        else
            session[:message] = "Time's up! Incorrect!"
            session[:color] = "red"
        end
    end

    # Metodo que maneja la opcion seleccionada por el usuario
    def handle_free_option_submission
        # Si el usuario selecciono una opcion
        if params[:option_id].to_i > 0
            # Buscamos la opcion y su pregunta relacionada
            @option = Option.find(params[:option_id].to_i)
            @question = @option.question
            # Si la opcion es correcta
            if @option.correct
                Answer.create(question_id: @question.id, user_id: @current_user.id, option_id: @option.id)
                @current_user.increment!(:cant_coins, 10)
                @current_user.increment!(:total_points, 50*$racha)
                $racha = $racha + 1
                session[:message] = "Correct! Well done."
                session[:color] = "green"
            elsif session[:inmunity]
                # Si la opcion es incorrecta pero tiene la inmunidad activada
                session[:inmunity] = false
                session[:message] = "Activate inmunity"
                session[:color] = "green"
            else
                # Si la opcion es incorrecta y no tiene la inmunidad activada llamamos
                # al metodo que maneja la respuesta incorrecta
                handle_free_incorrect_answer
            end
            # Guardamos la pregunta respondida asi no vuelve a aparecer
            session[:answered_free_questions] ||= []
            session[:answered_free_questions] << @question.id
        elsif session[:inmunity]
            # Si el usuario no selecciono una opcion pero tiene la inmundad activada
            session[:inmunity] = false
            session[:message] = "Activate inmunity"
            session[:color] = "green"
        else
            # Si el usuario no selecciono ninguna opcion
            session[:message] = "Invalid option ID"
            session[:color] = "red"
            redirect '/gamemodes'
        end
    end

    # Metodo que maneja lo que pasa cuando la respuesta es incorrecta
    def handle_free_incorrect_answer
        # Reseteamos la recha y le restamos 1 vida
        $racha = 1
        @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
        # Verificamos que el usuario pueda seguir jugando
        if @current_user.cant_life.zero?
            session[:message] = "You have 0 lives. Please wait for lives to regenerate."
            session[:color] = "red"
            redirect '/gamemodes'
        else
            session[:message] = "Incorrect!"
            session[:color] = "red"
        end
    end

end
