# frozen_string_literal: true

require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'bcrypt'
require './models/user'
require './models/profile'
require './models/gamemode'
require './models/answer'
require './models/option'
require './models/question'

require_relative './helpers/helpers'
require_relative './controllers/users_controller'
require_relative './controllers/profile_controller'
require_relative './controllers/wildcards_controller'
require_relative './controllers/admin_controller'
require_relative './controllers/grandprix_controller'
require_relative './controllers/free_controller'
require_relative './controllers/progressive_controller'

set :database_file, './config/database.yml'
set :public_folder, "#{File.dirname(__FILE__)}/public"

enable :sessions

# Esta clase define la aplicación principal utilizando Sinatra.
# Controla las rutas y la lógica de la aplicación web.
class App < Sinatra::Application
  use UsersController
  use ProfileController
  use WildCardsController
  use AdminController
  use GrandprixController
  use FreeController
  use ProgressiveController

  configure do
    set :views, './views'
  end

  # para asegurarse de que toda la inicialización necesaria en las clases se realice correctamente
  def initialize(_app = nil)
    super()
  end

  # para limpiar la cache
  before do
    cache_control :no_cache, :no_store, :must_revalidate
    expires 0, :public, :no_cache

    if session[:username]
      current_user = User.find_by(username: session[:username])
      current_user&.regenerate_life_if_needed
    end
  end

  before do
    # apenas entras se pueden a estas 5 rutas nada mas.
    if request.path_info == '/' || request.path_info == '/login' || request.path_info == '/register' ||
       request.path_info == '/how-to-play' || request.path_info == '/team'
      pass
    end
    # redirigir al inicio si no hay usuario en la sesión
    redirect '/' unless session[:username]
  end

  # pagina apenas entras a la app.
  get '/' do
    erb :'home/home'
  end

  # como jugar
  get '/how-to-play' do
    erb :'how-to-play/howToPlay'
  end

  # Team
  get '/team' do
    erb :'team/team'
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
      { lives: @current_user.cant_life }.to_json
    else
      erb :'progressives/progressives', locals: { current_user: @current_user }
    end
  end
end
