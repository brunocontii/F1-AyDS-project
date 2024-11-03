# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require_relative '../helpers/helpers'
require_relative '../models/user'
require_relative '../models/profile'
require_relative '../models/question'
require_relative '../models/answer'
require_relative '../modules/free_logic'

# Controlador que maneja el modo Free
class FreeController < Sinatra::Base
  include FreeLogic
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

  # Modo Free
  get '/gamemodes/free' do
    @current_user = User.find_by(username: session[:username]) if session[:username]

    # Reinicia el modo de juego si el usuario vuelve a ingresar
    reset_free_mode if session[:reset_free_mode]

    unless @current_user&.can_play?
      set_message_and_redirect('You have 0 lives. Please wait for lives to regenerate.', 'red')
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
    @current_user = User.find_by(username: session[:username]) if session[:username]

    unless @current_user&.can_play?
      set_message_and_redirect('You have 0 lives. Please wait for lives to regenerate.', 'red')
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

  # reseteo cuando termina imposible para comenzar a jugar de nuevo si quisiera
  def reset_free_mode
    session[:reset_free_mode] = false
    free_answers = Answer.joins(:question).where(questions: { theme: 'free' })
    Answer.where(id: free_answers.pluck(:id)).destroy_all
  end
end
