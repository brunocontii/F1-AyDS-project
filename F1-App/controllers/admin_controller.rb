# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require_relative '../models/user'
require_relative '../models/profile'
require_relative '../models/question'
require_relative '../models/option'

# Controlador para las funciones del usuario admin
class AdminController < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  configure do
    set :views, './views'
  end

  get '/profile/add-question' do
    @current_user = User.find_by(username: session[:username]) if session[:username]
    @profile = @current_user.profile

    redirect '/profile' if @current_user.admin != true

    erb :'profiles/add-question', locals: { current_user: @current_user, profile: @profile }
  end

  post '/profile/add-question' do
    question_type = params[:question_type]

    # Inicializa la variable question
    question = nil

    if question_type == 'text'
      question = question_text(params)
    elsif question_type == 'image'
      question = question_image(params)
    end

    save_question(question) if question

    redirect '/profile/add-question'
  end

  def question_text(params)
    # Verificar si la pregunta de texto ya existe
    existing_question = Question.find_by(name_question: params[:question_text])
    if existing_question
      flash[:error] = 'The question already exists in the database.'
    else
      # Crear la pregunta de texto
      Question.new(name_question: params[:question_text],
                   level: params[:difficulty], theme: params[:theme])
    end
  end

  def question_image(params)
    unless params[:question_image]&.dig(:filename)
      flash[:error] = 'Please upload an image.' and return redirect '/profile/add-question'
    end

    filename = params[:question_image][:filename]
    file = params[:question_image][:tempfile]

    # Validacion de tipo de archivo
    unless ['.jpg', '.jpeg', '.png'].include?(File.extname(filename).downcase)
      flash[:error] = 'Invalid image format.' and return redirect '/profile/add-question'
    end

    # Guardar la imagen en la carpeta publica
    File.write(File.join('public/grandprix', filename), file.read, mode: 'wb')

    # Crear la pregunta con la ruta de la imagen
    Question.new(image_question: "/grandprix/#{filename}", level: params[:difficulty], theme: params[:theme])
  end

  def save_question(question)
    if question.save
      # Guardar las opciones
      (1..4).each do |i|
        Option.create(name_option: params["option#{i}"],
                      question_id: question.id, correct: params[:correct_answer] == "option#{i}")
      end
      flash[:success] = 'Question added successfully!'
    else
      flash[:error] = "There was an error adding the question: #{question.errors.full_messages.join(', ')}"
    end
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
end
