# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require_relative '../helpers/helpers'
require_relative '../models/user'
require_relative '../models/profile'
require_relative '../models/question'
require_relative '../models/answer'
require_relative '../modules/grandprix_logic'

# Controlador que maneja el modo Grand Prix
class GrandprixController < Sinatra::Base
  include GrandPrixLogic
  helpers AppHelpers

  configure do
    enable :sessions
    register Sinatra::Flash
    set :views, './views'
    set :public_folder, './public'
  end

  before do
    # Lista de rutas a las que se puede acceder sin estar autenticado
    routes = ['/', '/login', '/register', '/how-to-play', '/team']

    # Redirigir si el usuario no esta autenticado y la ruta no esta en la lista permitida
    redirect '/' unless session[:username] || routes.include?(request.path_info)
  end

  # Modo Grand Prix
  get '/gamemodes/grandprix' do
    @current_user = User.find_by(username: session[:username]) if session[:username]

    # Reinicia el modo de juego si el usuario vuelve a ingresar
    reset_grandprix_mode if session[:reset_grandprix_mode]

    unless @current_user&.can_play?
      set_message_and_redirect('You have 0 lives. Please wait for lives to regenerate.', 'red')
    end

    session[:answered_grandprix_questions] ||= []
    session[:grandprix_mode_difficulty] ||= 'easy'
    answered_by_user_ids = Answer.where(user_id: @current_user.id).pluck(:question_id)
    unanswered_questions = Question.where(level: session[:grandprix_mode_difficulty], theme: 'grandprix')
                                   .where.not(id: answered_by_user_ids)
                                   .order('RANDOM()')

    if unanswered_questions.exists?
      @question = unanswered_questions.first
    else
      advance_difficulty
      redirect('/gamemodes') && return if session[:reset_grandprix_mode]

      redirect '/gamemodes/grandprix'
    end

    @options = @question.options.shuffle
    feedback_message = session.delete(:message)
    feedback_color = session.delete(:color)
    @form_action = '/gamemodes/grandprix'

    erb :'questions/questions', locals: { current_user: @current_user, question: @question,
                                          options: @options, feedback_message:, feedback_color: }
  end

  post '/gamemodes/grandprix' do
    @current_user = User.find_by(username: session[:username]) if session[:username]

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

  private

  # manejando la dificultad y los mensajes correspondientes
  def advance_difficulty
    case session[:grandprix_mode_difficulty]
    when 'easy'
      set_difficulty_and_message_grandprix('normal',
                                           "You've answered all the easy questions. Now the medium questions.")
    when 'normal'
      set_difficulty_and_message_grandprix('difficult',
                                           "You've answered all the medium questions. Now the hard questions.")
    when 'difficult'
      set_difficulty_and_message_grandprix('impossible',
                                           "You've answered all the hard questions. Now the impossible questions.")
    when 'impossible'
      set_difficulty_and_message_grandprix('easy', "Congratulations! You've completed the Grand Prix Mode.")
      session[:answered_grandprix_questions] = []
      session[:reset_grandprix_mode] = true
    end
  end

  # reseteo cuando termina imposible para comenzar a jugar de nuevo si quisiera
  def reset_grandprix_mode
    session[:reset_grandprix_mode] = false
    grandprix_answers = Answer.joins(:question).where(questions: { theme: 'grandprix' })
    Answer.where(id: grandprix_answers.pluck(:id)).destroy_all
  end
end
