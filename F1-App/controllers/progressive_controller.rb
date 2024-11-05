# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require_relative '../helpers/helpers'
require_relative '../models/user'
require_relative '../models/profile'
require_relative '../models/question'
require_relative '../models/answer'
require_relative '../modules/progressive_logic'

# Controlador que maneja todos los modos de juego dentro del modo Progressive
class ProgressiveController < Sinatra::Base
  include ProgressiveLogic

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
    # Obtiene el usuario actual de la sesión
    find_current_user

    unless @current_user&.can_play?
      return set_message_and_redirect('You have 0 lives. Please wait for lives to regenerate.', 'red')
    end

    # Inicializa preguntas respondidas
    session[:answered_questions] ||= []
    answered_by_user_ids = Answer.where(user_id: @current_user.id).pluck(:question_id)

    # Selecciona una pregunta sin responder relacionada al tema seleccionado
    @question = select_question(mode, answered_by_user_ids)

    # Redirige si no hay preguntas disponibles
    return set_message_and_redirect('¡Congratulations, you finished this theme!', 'green') if @question.nil?

    # Ordena las opciones de respuesta de manera aleatoria
    @options = @question.options.to_a.shuffle

    # Prepara los mensajes de feedback
    feedback_message, feedback_color = clear_feedback_messages

    # Configura la acción del formulario para el modo progresivo
    @form_action = "/gamemodes/progressive/#{mode}"

    # Renderiza la vista con las variables necesarias
    erb :'questions/questions',
        locals: { current_user: @current_user, question: @question, options: @options, feedback_message:,
                  feedback_color: }
  end

  # metodo para manejar la solicitud POST de un tema del modo progresivo
  def handle_progressive_mode_submission(mode)
    @current_user = User.find_by(username: session[:username]) if session[:username]

    unless @current_user&.can_play?
      set_message_and_redirect('You have 0 lives. Please wait for lives to regenerate.', 'red')
    end

    params[:timeout] == 'true' && !session[:inmunity] ? handle_timeout : handle_option_submission
    redirect "/gamemodes/progressive/#{mode}"
  end

  private

  def find_current_user
    @current_user = User.find_by(username: session[:username]) if session[:username]
  end

  def select_question(mode, answered_by_user_ids)
    Question.where(theme: mode).where.not(id: answered_by_user_ids).order('RANDOM()').first
  end

  def clear_feedback_messages
    [session.delete(:message), session.delete(:color)]
  end
end
