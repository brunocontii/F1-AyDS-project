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
    # obtenemos el usuario actual de la sesion
    @current_user = User.find_by(username: session[:username]) if session[:username]

    # verificamos si tiene vidas para jugar
    unless @current_user&.can_play?
      set_message_and_redirect('You have 0 lives. Please wait for lives to regenerate.', 'red')
    end

    session[:answered_questions] ||= []
    answered_by_user_ids = Answer.where(user_id: @current_user.id).pluck(:question_id)

    # seleccionamos una pregunta relacionada al tema seleccionado por el usuario,
    # que no haya sido respondida todavia
    @question = Question.where(theme: mode).where.not(id: answered_by_user_ids).order('RANDOM()').first

    set_message_and_redirect('¡Congratulations, you finished this theme!', 'green') if @question.nil?

    # ordenamos las opciones de manera random
    @options = @question.options.to_a.shuffle

    feedback_message = session.delete(:message)
    feedback_color = session.delete(:color)
    @form_action = "/gamemodes/progressive/#{mode}"

    erb :'questions/questions',
        locals: { current_user: @current_user, question: @question, options: @options,
                  feedback_message:, feedback_color: }
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
end
