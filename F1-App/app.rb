require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'

set :database_file, './config/database.yml'

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
        'Welcome'
    end

    get '/users' do
        @users = User.all
        erb :'users/index'
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