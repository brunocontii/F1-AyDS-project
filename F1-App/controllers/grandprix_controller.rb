# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require_relative '../models/user'
require_relative '../models/profile'
require_relative '../models/question'
require_relative '../models/answer'
require_relative '../modules/grandprix_logic'

# Controlador que maneja el modo Grand Prix
class GrandprixController < Sinatra::Base
  include GrandPrixLogic

  enable :sessions
  register Sinatra::Flash

  configure do
    set :views, './views'
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
end
