# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require_relative '../models/user'
require_relative '../models/profile'
require_relative '../models/question'
require_relative '../models/answer'
require_relative '../modules/free_logic'

# Controlador que maneja el modo Free
class FreeController < Sinatra::Base
  include FreeLogic

  enable :sessions
  register Sinatra::Flash

  configure do
    set :views, './views'
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
end
