# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require_relative '../models/user'
require_relative '../models/profile'
require_relative '../models/question'
require_relative '../models/option'

# Controlador para las funciones del usuario admin
class AdminController < Sinatra::Base
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

  get '/profile/add-question' do
    @current_user = User.find_by(username: session[:username]) if session[:username]
    @profile = @current_user.profile

    redirect '/profile' if @current_user.admin != true

    erb :'profiles/add-question', locals: { current_user: @current_user, profile: @profile }
  end

  post '/profile/add-question' do
    question_type = params[:question_type]

    question = nil

    # si es texto o imagen la pregunta a agregar
    if question_type == 'text'
      question = question_text(params)
    elsif question_type == 'image'
      question = question_image(params)
    end

    # si hay una pregunta que la guarde
    save_question(question) if question

    redirect '/profile/add-question'
  end

  get '/profile/view-question-data' do
    @current_user = User.find_by(username: session[:username]) if session[:username]
    @profile = @current_user.profile

    redirect '/profile' if @current_user.admin != true

    @view_type = params[:view_type]
    limit = params[:limit].to_i

    @questions = if @view_type && limit
                   if @view_type == 'correct'
                     Question.order(correct: :desc).limit(limit)
                   else
                     Question.order(incorrect: :desc).limit(limit)
                   end
                 else
                   []
                 end

    erb :'profiles/view-question-data', locals: { profile: @profile, questions: @questions }
  end

  private

  def question_text(params)
    existing_question = Question.find_by(name_question: params[:question_text])
    if existing_question
      flash[:error] = 'The question already exists in the database.'
      nil
    else
      Question.new(name_question: params[:question_text],
                   level: params[:difficulty], theme: params[:theme])
    end
  end

  def question_image(params)
    flash[:error] = 'Please upload an image.' and return nil unless params[:question_image]&.dig(:filename)

    filename = params[:question_image][:filename]
    file = params[:question_image][:tempfile]

    unless ['.jpg', '.jpeg', '.png'].include?(File.extname(filename).downcase)
      flash[:error] = 'Invalid image format.' and return nil
    end

    File.write(File.join('public/grandprix', filename), file.read, mode: 'wb')

    Question.new(image_question: "/grandprix/#{filename}", level: params[:difficulty], theme: params[:theme])
  end

  def save_question(question)
    if question.save
      (1..4).each do |i|
        Option.create(name_option: params["option#{i}"],
                      question_id: question.id, correct: params[:correct_answer] == "option#{i}")
      end
      flash[:success] = 'Question added successfully!'
    else
      flash[:error] = "There was an error adding the question: #{question.errors.full_messages.join(', ')}"
    end
  end
end
