# frozen_string_literal: true

require 'sinatra/base'
require_relative '../models/user'
require_relative '../models/question'
require_relative '../models/option'

# Controlador que maneja la logica de los comodines
class WildCardsController < Sinatra::Base
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

  post '/use_extra_time' do
    content_type :json
    params = parse_request_body

    # Extraemos el usuario desde los parámetros y lo buscamos
    user_id = params['user_id']
    @current_user = User.find(user_id)

    # Caso donde el usuario puede comprar el comodín
    if @current_user&.cant_coins.to_i >= 75
      @current_user.update!(cant_coins: @current_user.cant_coins - 75)
      { status: 'success' }.to_json
    else
      { status: 'error', message: 'Not enough coins' }.to_json
    end
  end

  post '/use_50_50' do
    content_type :json
    params = parse_request_body

    user_id = params['user_id']
    @current_user = User.find(user_id)
    question_id = params['question_id']
    question = Question.find(question_id)
    options = question.options

    if @current_user&.cant_coins.to_i >= 150
      @current_user.update(cant_coins: @current_user.cant_coins - 150)

      # Seleccionar 2 opciones incorrectas al azar
      incorrect_options = options.reject(&:correct).sample(2)
      incorrect_option_ids = incorrect_options.map(&:id)

      { status: 'success', removed_options: incorrect_option_ids }.to_json
    else
      { status: 'error', message: 'Not enough coins' }.to_json
    end
  end

  post '/inmunity' do
    content_type :json
    params = parse_request_body

    user_id = params['user_id']
    @current_user = User.find(user_id)

    if @current_user&.cant_coins.to_i >= 200
      session[:inmunity] = true
      @current_user.update!(cant_coins: @current_user.cant_coins - 200)
      { status: 'success' }.to_json
    else
      { status: 'error', message: 'Not enough coins' }.to_json
    end
  end

  private

  def parse_request_body
    request_body = request.body.read
    JSON.parse(request_body)
  end
end
