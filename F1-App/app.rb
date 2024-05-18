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


class App < Sinatra::Application
    def initialize(app = nil)
        super()
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

    get '/profiles' do
        @profiles = Profile.all
        erb :'profiles/index'
    end

    get '/gamemodes' do
        @gamemodes = Gamemode.all
        erb :'gamemodes/index'
    end

    get '/frees' do
        @frees = Free.all
        erb :'frees/index'
    end

    get '/progressives' do
        @progressives = Progressive.all
        erb :'progressives/index'
    end

    get '/answers' do
        @answers = Answer.all
        erb :'answers/index'
    end

    get '/replies' do
        @replies = Reply.all
        erb :'replies/index'
    end

    get '/buys' do
        @buys = Buy.all
        erb :'buys/index'
    end

    get '/wildcards' do
        @wildcards = Wildcard.all
        erb :'wildcards/index'
    end

    get '/questions' do
        @questions = Question.all
        erb :'questions/index'
    end

    get '/options' do
        @options = Option.all
        erb :'options/index'
    end
end
