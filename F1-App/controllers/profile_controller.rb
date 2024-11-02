# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require_relative '../models/user'
require_relative '../models/profile'
require_relative '../models/question'
require_relative '../models/answer'

# Controlador que maneja las funciones basicas de cualquier usuario
class ProfileController < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  configure do
    set :views, './views'
  end

  # Muestra el perfil de usuario
  get '/profile' do
    @current_user = User.find_by(username: session[:username]) if session[:username]

    if request.xhr?
      content_type :json
      { lives: @current_user.cant_life }.to_json
    else
      @profile = @current_user.profile if @current_user
      @count_pi = calculate_progress(@current_user, 'pilot')
      @count_ci = calculate_progress(@current_user, 'circuit')
      @count_ca = calculate_progress(@current_user, 'career')
      @count_te = calculate_progress(@current_user, 'team')
      @count_tot = calculate_progress(@current_user)
      erb :'profiles/profile', locals: {
        profile: @profile, countPi: @count_pi, countCi: @count_ci,
        countCa: @count_ca, countTe: @count_te, countTot: @count_tot
      }
    end
  end

  # Actualizar la foto de perfil
  post '/profile/picture' do
    @current_user = User.find_by(username: session[:username]) if session[:username]
    if @current_user
      @profile = @current_user.profile
      @profile.update(profile_picture: params[:profile_picture])
    end
    redirect '/profile'
  end

  # Mostrar formulario para cambiar contraseña
  get '/profile/change-password' do
    @current_user = User.find_by(username: session[:username]) if session[:username]
    @profile = @current_user.profile
    erb :'profiles/change-pass', locals: { profile: @profile }
  end

  # Cambiar la contraseña
  post '/profile/change_password' do
    @current_user = User.find_by(username: session[:username]) if session[:username]
    current_password = params[:current_password]
    new_password = params[:new_password]
    confirm_password = params[:confirm_password]

    if @current_user.authenticate(current_password)
      if new_password == confirm_password
        @current_user.update(password: new_password)
        flash[:success] = 'Password changed successfully.'
        redirect '/profile'
      else
        flash[:error] = 'The new passwords do not match.'
        redirect '/profile/change-password'
      end
    else
      flash[:error] = 'The current password is incorrect.'
      redirect '/profile/change-password'
    end
  end

  private

  # Metodo para calcular el progreso en diferentes temas
  def calculate_progress(user, theme = nil)
    if theme
      total_questions = Question.where(theme:).count
      return 0 unless total_questions.positive?

      correct_answers = Answer.where(user_id: user.id).joins(:question).where(questions: { theme: }).count
    else
      total_questions = Question.count
      return 0 unless total_questions.positive?

      correct_answers = Answer.where(user_id: user.id).count
    end

    (correct_answers * 100) / total_questions
  end
end
