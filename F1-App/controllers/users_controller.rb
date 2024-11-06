# frozen_string_literal: true

require 'sinatra/base'
require_relative '../models/user'
require_relative '../models/profile'

# Controlador que maneja el login y el registro del usuario
class UsersController < Sinatra::Base
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

  # Mostrar el view del login
  get '/login' do
    erb :'login/login'
  end

  # Post para el login de un usuario
  post '/login' do
    username_or_email = params[:username]
    password = params[:password]
    # Busca por username o por email
    user = User.find_by(username: username_or_email) || Profile.find_by(email: username_or_email)&.user
    # Si el usuario existe y la contraseña es correcta
    if user&.authenticate(password)
      # Guardar el nombre de usuario en la sesion
      session[:username] = user.username
      redirect '/gamemodes'
    else
      # Si el login falla por username/email o por contraseña incorrecta
      @error = 'Invalid username/email or password.'
      erb :'login/login'
    end
  end

  # Mostrar view del registro
  get '/register' do
    # lista de todas las fotos que se encuentran dentro de public/profile_pictures
    @profile_pictures = Dir.glob('public/profile_pictures/*').map { |path| path.split('/').last }
    erb :'register/register'
  end

  # Post para el registro de un usuario
  post '/register' do
    @profile_pictures = Dir.glob('public/profile_pictures/*').map { |path| path.split('/').last }
    # Si el usuario ya existe o las contraseñas no coinciden
    if validate_registration(params)
      erb :'register/register'
    # Si se pudo crear el usuario
    elsif create_user_profile(params)
      session[:username] = params[:username]
      redirect '/gamemodes'
    else
      @error = 'Failed to create the account. Please try again.'
      erb :'register/register'
    end
  end

  # Cerrar sesion
  get '/logout' do
    session.clear
    redirect '/'
  end

  private

  # Metodo para crear el usuario y su perfil
  def create_user_profile(params)
    user = User.new(
      username: params[:username], password: params[:password], cant_life: 3, cant_coins: 0, total_points: 0
    )

    return unless user.save

    Profile.create(
      name: params[:name], lastName: params[:lastname], email: params[:email],
      description: params[:description], age: params[:age], user:, profile_picture: params[:profile_pic]
    )
  end

  # Metodo para validar el registro
  def validate_registration(params)
    if User.where(username: params[:username]).exists?
      @error = 'Username already exists'
    elsif params[:password] != params[:repeat_password]
      @error = 'Passwords are different'
    end
  end
end
