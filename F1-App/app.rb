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

set :database_file, './config/database.yml'
set :public_folder, "#{File.dirname(__FILE__)}/public"

use UsersController
use ProfileController
use WildCardsController
use AdminController

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
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      redirect '/gamemodes'
    end

    session[:answered_free_questions] ||= []
    session[:free_mode_difficulty] ||= 'easy'

    next_question

    @options = @question.options.shuffle
    feedback_message = session.delete(:message)
    feedback_color = session.delete(:color)
    @form_action = '/gamemodes/free'

    erb :'questions/questions',
        locals: { current_user: @current_user, question: @question, options: @options,
                  feedback_message:, feedback_color: }
  end

  def next_question
    answered_by_user_ids = Answer.where(user_id: @current_user.id).pluck(:question_id)

    # Preguntas que aún no han sido respondidas en esta dificultad
    unanswered_questions = Question.where(level: session[:free_mode_difficulty], theme: 'free')
                                   .where.not(id: answered_by_user_ids)
                                   .order('RANDOM()')

    # Seleccionar la siguiente pregunta
    if unanswered_questions.exists?
      @question = unanswered_questions.first
    else
      handle_difficulty_progression
    end
  end

  def handle_difficulty_progression
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

      @question = all_questions.order('RANDOM()').first if all_questions.exists?
      redirect '/gamemodes'
    end
  end

  post '/gamemodes/free' do
    # Buscamos al usuario
    @current_user = User.find_by(username: session[:username]) if session[:username]

    # Verificamos que el usuario pueda jugar
    unless @current_user&.can_play?
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
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

  # Modo Grand Prix
  get '/gamemodes/grandprix' do
    @current_user = User.find_by(username: session[:username]) if session[:username]

    # Reinicia el modo de juego si el usuario vuelve a ingresar
    if session[:reset_grandprix_mode]
      session[:reset_grandprix_mode] = false
      grandprix_answers = Answer.joins(:question).where(questions: { theme: 'grandprix' })

      # Restar las respuestas del modo "grandprix" de la tabla completa de respuestas
      Answer.where(id: grandprix_answers.pluck(:id)).destroy_all
    end

    unless @current_user&.can_play?
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      redirect '/gamemodes'
    end

    session[:answered_grandprix_questions] ||= []
    session[:grandprix_mode_difficulty] ||= 'easy'
    answered_by_user_ids = Answer.where(user_id: @current_user.id).pluck(:question_id)
    # Preguntas que aún no han sido respondidas en esta dificultad
    unanswered_questions = Question.where(level: session[:grandprix_mode_difficulty], theme: 'grandprix')
                                   .where.not(id: answered_by_user_ids)
                                   .order('RANDOM()')

    # Seleccionar la siguiente pregunta
    if unanswered_questions.exists?
      @question = unanswered_questions.first
    else
      @question = Question.where(level: session[:grandprix_mode_difficulty])
                          .order('RANDOM()').first
      case session[:grandprix_mode_difficulty]
      when 'easy'
        session[:grandprix_mode_difficulty] = 'normal'
        session[:message] = "You've answered all the easy questions. Now the medium questions will appear."
      when 'normal'
        session[:grandprix_mode_difficulty] = 'difficult'
        session[:message] = "You've answered all the medium questions. Now the hard questions will appear."
      when 'difficult'
        session[:grandprix_mode_difficulty] = 'impossible'
        session[:message] = "You've answered all the hard questions. Now the impossible questions will appear."
      when 'impossible'
        session[:grandprix_mode_difficulty] = 'easy'
        session[:answered_grandprix_questions] = []
        session[:message] = "Congratulations! You've completed the Grand Prix Mode."
        session[:reset_grandprix_mode] = true
        all_questions = Question.all

        @question = all_questions.order('RANDOM()').first if all_questions.exists?
        redirect '/gamemodes'
      end
      redirect '/gamemodes/grandprix'
    end

    @options = @question.options.shuffle
    feedback_message = session.delete(:message)
    feedback_color = session.delete(:color)
    @form_action = '/gamemodes/grandprix'

    erb :'questions/questions',
        locals: { current_user: @current_user, question: @question, options: @options,
                  feedback_message:, feedback_color: }
  end

  post '/gamemodes/grandprix' do
    # Buscamos al usuario
    @current_user = User.find_by(username: session[:username]) if session[:username]

    # Verificamos que el usuario pueda jugar
    unless @current_user&.can_play?
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      return redirect '/gamemodes'
    end

    # Si se acabo el tiempo para responder y no tiene activada la inmunidad
    if params[:timeout] == 'true' && !session[:inmunity]
      # Metodo que maneja la expiracion del tiempo
      handle_grandprix_timeout
    else
      # Si no se agoto el tiempo, o tiene inmunidad, llamamos al metodo que maneja
      # la opcion seleccionada
      handle_grandprix_option_submission
    end

    redirect '/gamemodes/grandprix'
  end

  # Metodo que maneja lo que pasa cuando el tiempo para responder se acaba
  def handle_free_timeout
    # Restamos 1 vida al usuario
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
    # Verificamos si el usuario puede seguir jugando o no
    if @current_user.cant_life.zero?
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      redirect '/gamemodes'
    else
      session[:message] = "Time's up! Incorrect!"
      session[:color] = 'red'
    end
  end

  # Metodo que maneja la opcion seleccionada por el usuario
  def handle_free_option_submission
    # Si el usuario selecciono una opcion
    if params[:option_id].to_i.positive?
      # Buscamos la opcion y su pregunta relacionada
      @option = Option.find(params[:option_id].to_i)
      @question = @option.question
      # Si la opcion es correcta
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
        # Si la opcion es incorrecta pero tiene la inmunidad activada
        session[:inmunity] = false
        session[:message] = 'Activate inmunity'
        session[:color] = 'green'
      else
        # Si la opcion es incorrecta y no tiene la inmunidad activada llamamos
        # al metodo que maneja la respuesta incorrecta
        handle_free_incorrect_answer
      end
      # Guardamos la pregunta respondida asi no vuelve a aparecer
      (session[:answered_free_questions] ||= []) << @question.id
    elsif session[:inmunity]
      # Si el usuario no selecciono una opcion pero tiene la inmundad activada
      session[:inmunity] = false
      session[:message] = 'Activate inmunity'
      session[:color] = 'green'
    else
      # Si el usuario no selecciono ninguna opcion
      session[:message] = 'Invalid option ID'
      session[:color] = 'red'
      redirect '/gamemodes'
    end
  end

  # Metodo que maneja lo que pasa cuando la respuesta es incorrecta
  def handle_free_incorrect_answer
    # Incrementa la columna 'incorrect' en la pregunta que fue contestada incorrectamente
    @question.increment!(:incorrect)
    # Reseteamos la recha y le restamos 1 vida
    @current_user.update(racha: 1)
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
    # Verificamos que el usuario pueda seguir jugando
    if @current_user.cant_life.zero?
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      redirect '/gamemodes'
    else
      session[:message] = 'Incorrect!'
      session[:color] = 'red'
    end
  end

  # Metodo que maneja lo que pasa cuando el tiempo para responder se acaba
  def handle_grandprix_timeout
    # Restamos 1 vida al usuario
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
    # Verificamos si el usuario puede seguir jugando o no
    if @current_user.cant_life.zero?
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      redirect '/gamemodes'
    else
      session[:message] = "Time's up! Incorrect!"
      session[:color] = 'red'
    end
  end

  # Metodo que maneja la opcion seleccionada por el usuario
  def handle_grandprix_option_submission
    # Si el usuario selecciono una opcion
    if params[:option_id].to_i.positive?
      # Buscamos la opcion y su pregunta relacionada
      @option = Option.find(params[:option_id].to_i)
      @question = @option.question
      # Si la opcion es correcta
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
        # Si la opcion es incorrecta pero tiene la inmunidad activada
        session[:inmunity] = false
        session[:message] = 'Activate inmunity'
        session[:color] = 'green'
      else
        # Si la opcion es incorrecta y no tiene la inmunidad activada llamamos
        # al metodo que maneja la respuesta incorrecta
        handle_grandprix_incorrect_answer
      end
      # Guardamos la pregunta respondida asi no vuelve a aparecer
      (session[:answered_grandprix_questions] ||= []) << @question.id
    elsif session[:inmunity]
      # Si el usuario no selecciono una opcion pero tiene la inmundad activada
      session[:inmunity] = false
      session[:message] = 'Activate inmunity'
      session[:color] = 'green'
    else
      # Si el usuario no selecciono ninguna opcion
      session[:message] = 'Invalid option ID'
      session[:color] = 'red'
      redirect '/gamemodes'
    end
  end

  # Metodo que maneja lo que pasa cuando la respuesta es incorrecta
  def handle_grandprix_incorrect_answer
    # Incrementa la columna 'incorrect' en la pregunta que fue contestada incorrectamente
    @question.increment!(:incorrect)
    # Reseteamos la recha y le restamos 1 vida
    @current_user.update(racha: 1)
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
    # Verificamos que el usuario pueda seguir jugando
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
