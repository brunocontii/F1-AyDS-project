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

require_relative './controllers/users_controller'
require_relative './controllers/profile_controller'
require_relative './controllers/wildcards_controller'
require_relative './controllers/admin_controller'
require_relative './controllers/grandprix_controller'
require_relative './controllers/free_controller'

set :database_file, './config/database.yml'
set :public_folder, "#{File.dirname(__FILE__)}/public"

use UsersController
use ProfileController
use WildCardsController
use AdminController
use GrandprixController
use FreeController

enable :sessions

# Esta clase define la aplicación principal utilizando Sinatra.
# Controla las rutas y la lógica de la aplicación web.
class App < Sinatra::Application
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

  # generalizacion de las rutas del modo de juego progresivo
  # se crean las rutas de manera dinamica para cada tema del modo progresivo
  %w[pilot team career circuit].each do |mode|
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
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      redirect '/gamemodes'
    end

    session[:answered_questions] ||= []
    answered_by_user_ids = Answer.where(user_id: @current_user.id).pluck(:question_id)

    # seleccionamos una pregunta relacionada al tema seleccionado por el usuario,
    # que no haya sido respondida todavia
    @question = Question.where(theme: mode).where.not(id: answered_by_user_ids).order('RANDOM()').first

    if @question.nil?
      session[:message] = '¡Congratulations, you finished this theme!'
      session[:color] = 'green'
      redirect '/gamemodes'
    end

    # ordenamos las opciones de manera random
    @options = @question.options.to_a.shuffle

    feedback_message = session.delete(:message)
    feedback_color = session.delete(:color)
    @form_action = "/gamemodes/progressive/#{mode}"

    erb :'questions/questions',
        locals: { current_user: @current_user, question: @question, options: @options,
                  feedback_message:, feedback_color: }
  end

  def handle_progressive_mode_submission(mode)
    @current_user = User.find_by(username: session[:username]) if session[:username]

    unless @current_user&.can_play?
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      return redirect '/gamemodes'
    end

    params[:timeout] == 'true' && !session[:inmunity] ? handle_timeout : handle_option_submission
    redirect "/gamemodes/progressive/#{mode}"
  end

  private

  def handle_timeout
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
    if @current_user.cant_life.zero?
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      redirect '/gamemodes'
    else
      session[:message] = "Time's up! Incorrect!"
      session[:color] = 'red'
    end
  end

  def handle_option_submission
    if params[:option_id].to_i.positive?
      @option = Option.find(params[:option_id].to_i)
      @question = @option.question
      if @option.correct
        Answer.create(question_id: @question.id, user_id: @current_user.id, option_id: @option.id)
        # Incrementa la columna 'correct' en la pregunta que fue contestada correctamente
        @question.increment!(:correct)
        @current_user.increment!(:cant_coins, 10)
        @current_user.increment!(:total_points, 50 * @current_user.racha)
        @current_user.increment!(:racha)
        session[:message] = 'Correct! Well done.'
        session[:color] = 'green'
      elsif session[:inmunity]
        session[:inmunity] = false
        session[:message] = 'Activate inmunity'
        session[:color] = 'green'
      else
        handle_incorrect_answer
      end
      (session[:answered_questions] ||= []) << @question.id
    elsif session[:inmunity]
      session[:inmunity] = false
      session[:message] = 'Activate inmunity'
      session[:color] = 'green'
    else
      session[:message] = 'Invalid option ID'
      session[:color] = 'red'
      redirect '/gamemodes'
    end
  end

  def handle_incorrect_answer
    # Incrementa la columna 'incorrect' en la pregunta que fue contestada incorrectamente
    @question.increment!(:incorrect)
    @current_user.update(racha: 1)
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
    if @current_user.cant_life.zero?
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      redirect '/gamemodes'
    else
      session[:message] = 'Incorrect!'
      session[:color] = 'red'
    end
  end
end
