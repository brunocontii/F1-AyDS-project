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
    def initialize(app = nil)
        super()
    end

    before do
        cache_control :no_cache, :no_store, :must_revalidate
        expires 0, :public, :no_cache

        if session[:username]
            current_user = User.find_by(username: session[:username])
            current_user.regenerate_life_if_needed if current_user
        end
    end

    get '/' do
        erb :'home/home'
    end

    get '/login' do
        erb :'login/login'
    end

    post '/login' do
        username = params[:username]
        password = params[:password]

        user = User.find_by(username: username, password: password)

        if user
            session[:username] = user.username # Guardar el nombre de usuario en la sesión
            redirect "/gamemodes"
        else
            @error = "Invalid username or password. Please try again."
            erb :'login/login'
        end
    end

    get '/users' do
        @users = User.all
        erb :'users/index'
    end

    get '/register' do
        erb :'register/index'
    end

    post '/register' do
        username = params[:username]
        password = params[:password]
        rpassword = params[:repeat_password]

        if User.where(username: username).exists?
            @error = "Username already exist"
            erb :'register/index'
        elsif password != rpassword
            @error = "Passwords are different"
            erb :'register/index'
        else
            user = User.new(username: username, password: password)
            session[:username] = user.username
            redirect '/gamemodes'
        end

    end

    get '/logout' do
        session.clear
        redirect '/'
    end

    get '/how-to-play' do
        erb :'how-to-play/howToPlay'
    end

    get '/profile' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        @profile = @current_user.profile if @current_user
        erb :'profiles/index', locals: { profile: @profile }
    end

    get '/gamemodes' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        if request.xhr?
            content_type :json
            { lives: @current_user.cant_life }.to_json
        else
            erb :'gamemodes/menu', locals: { current_user: @current_user }
        end
    end

    get '/gamemodes/progressive' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        erb :'progressives/index' , locals: { current_user: @current_user }
    end

    get '/gamemodes/progressive/pilot' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        
        unless @current_user&.can_play?
            session[:message] = "Yo have 0 lives. Please wait for loves to regenerate."
            session[:color] = "red"
            redirect '/gamemodes'
            return
        end

        session[:answered_questions] ||= []

        @question = Question.where(theme: 'pilot').where.not(id: session[:answered_questions]).order('RANDOM()').first
        if @question.nil?
            session[:answered_questions] = []
            @question = Question.where(theme: 'pilot').order('RANDOM()').first
        end
        @options = @question.options.shuffle

        feedback_message = session.delete(:message)
        feedback_color = session.delete(:color)
        @form_action = '/gamemodes/progressive/pilot'

        erb :'questions/index', locals: { current_user: @current_user, question: @question, options: @options, feedback_message: feedback_message, feedback_color: feedback_color}
    end

    post '/gamemodes/progressive/pilot' do
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
        end

        session[:answered_questions] ||= []
        session[:answered_questions] << @question.id

        redirect '/gamemodes/progressive/pilot'
    end

    get '/gamemodes/progressive/team' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        
        unless @current_user&.can_play?
            session[:message] = "You have 0 lives. Please wait for loves to regenerate."
            session[:color] = "red"
            redirect '/gamemodes'
            return
        end
        
        session[:answered_questions] ||= []

        @question = Question.where(theme: 'team').where.not(id: session[:answered_questions]).order('RANDOM()').first
        if @question.nil?
            session[:answered_questions] = []
            @question = Question.where(theme: 'team').order('RANDOM()').first
        end
        @options = @question.options.shuffle

        feedback_message = session.delete(:message)
        feedback_color = session.delete(:color)
        @form_action = '/gamemodes/progressive/team'

        erb :'questions/index', locals: { current_user: @current_user, question: @question, options: @options, feedback_message: feedback_message, feedback_color: feedback_color}
    end

    post '/gamemodes/progressive/team' do
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
                session[:message] = "You have 0 lives. Please wait for loves to regenerate."
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

        session[:answered_questions] ||= []
        session[:answered_questions] << @question.id
            
        redirect '/gamemodes/progressive/team'
    end

    get '/gamemodes/progressive/career' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        
        unless @current_user&.can_play?
            session[:message] = "You have 0 lives. Please wait for loves to regenerate."
            session[:color] = "red"
            redirect '/gamemodes'
            return
        end
        
        session[:answered_questions] ||= []

        @question = Question.where(theme: 'career').where.not(id: session[:answered_questions]).order('RANDOM()').first
        if @question.nil?
            session[:answered_questions] = []
            @question = Question.where(theme: 'career').order('RANDOM()').first
        end
        @options = @question.options.shuffle

        feedback_message = session.delete(:message)
        feedback_color = session.delete(:color)
        @form_action = '/gamemodes/progressive/career'

        erb :'questions/index', locals: { current_user: @current_user, question: @question, options: @options, feedback_message: feedback_message, feedback_color: feedback_color}
    end

    post '/gamemodes/progressive/career' do
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
                session[:message] = "You have 0 lives. Please wait for loves to regenerate."
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

        session[:answered_questions] ||= []
        session[:answered_questions] << @question.id
            
        redirect '/gamemodes/progressive/career'
    end

    get '/gamemodes/progressive/circuit' do
        @current_user = User.find_by(username: session[:username]) if session[:username]
        
        unless @current_user&.can_play?
            session[:message] = "You have 0 lives. Please wait for loves to regenerate."
            session[:color] = "red"
            redirect '/gamemodes'
            return
        end
        
        session[:answered_questions] ||= []

        @question = Question.where(theme: 'circuit').where.not(id: session[:answered_questions]).order('RANDOM()').first
        if @question.nil?
            session[:answered_questions] = []
            @question = Question.where(theme: 'circuit').order('RANDOM()').first
        end
        @options = @question.options.shuffle

        feedback_message = session.delete(:message)
        feedback_color = session.delete(:color)
        @form_action = '/gamemodes/progressive/circuit'

        erb :'questions/index', locals: { current_user: @current_user, question: @question, options: @options, feedback_message: feedback_message, feedback_color: feedback_color}
    end

    post '/gamemodes/progressive/circuit' do
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
                session[:message] = "You have 0 lives. Please wait for loves to regenerate."
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

        session[:answered_questions] ||= []
        session[:answered_questions] << @question.id

            
        redirect '/gamemodes/progressive/circuit'
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
  
        erb :'questions/index', locals: { current_user: @current_user, question: @question, options: @options, feedback_message: feedback_message, feedback_color: feedback_color }
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

    get '/buys' do
        @buys = Buy.all
        erb :'buys/index'
    end

    get '/wildcards' do
        @wildcards = Wildcard.all
        erb :'wildcards/index'
    end

end
