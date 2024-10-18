# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require_relative '../app'
require 'rspec'
require 'rack/test'

RSpec.describe 'The App' do
  include Rack::Test::Methods

  def app
    # Sinatra::Appplication
    App
  end

  describe 'POST /use_extra_time' do
    let!(:user) { User.create(username: 'testuser', password: 'password123', cant_coins: 100) }

    before do
      env 'rack.session', { username: user.username }
    end

    context 'when the user has enough coins' do
      # Puede usar el comodin , pierde 75 monedas.
      it 'reduces the user coins and returns success status' do
        request_body = { user_id: user.id }.to_json

        post '/use_extra_time', request_body, { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.content_type).to eq('application/json')
        expect(last_response.status).to eq(200)
        updated_user = User.find(user.id)
        expect(updated_user.reload.cant_coins).to eq(25) # Se espera que se reduzcan 75 monedas

        # Respuesta JSON sea la esperada
        json_response = JSON.parse(last_response.body)
        expect(json_response).to eq({ 'status' => 'success' })
      end
    end

    context 'when the user does not have enough coins' do
      # No puede usar el comodin
      it 'does not reduce the coins and does not return success' do
        # Actualiza las monedas del usuario para que no tenga suficientes y probar
        user.update(cant_coins: 50)
        request_body = { user_id: user.id }.to_json
        post '/use_extra_time', request_body, { 'CONTENT_TYPE' => 'application/json' }
        expect(user.reload.cant_coins).to eq(50) # Las monedas deben permanecer igual
      end
    end
  end

  describe 'POST /use_50_50' do
    # Preparando usuario y pregunta con sus respuestas
    let!(:user) { User.create(username: 'testuser', password: 'password123', cant_coins: 160) }
    let!(:question) { Question.create(name_question: 'Sample Question', level: 'easy', theme: 'free') }
    let!(:correct_option) { Option.create(name_option: 'Correct Answer', correct: true, question: question) }
    let!(:incorrect_option1) do
      Option.create(name_option: 'Incorrect Option 1', question_id: question.id, correct: false)
    end
    let!(:incorrect_option2) do
      Option.create(name_option: 'Incorrect Option 1', question_id: question.id, correct: false)
    end
    let!(:incorrect_option3) do
      Option.create(name_option: 'Incorrect Option 1', question_id: question.id, correct: false)
    end

    before do
      env 'rack.session', { username: user.username }
    end

    context 'when the user has enough coins' do
      # Puede usar el comodin , pierde 150 monedas
      it 'reduces the user coins and returns success status' do
        request_body = { user_id: user.id, question_id: question.id }.to_json

        post '/use_50_50', request_body, { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.content_type).to eq('application/json')
        expect(last_response.status).to eq(200)

        updated_user = User.find(user.id)

        expect(updated_user.reload.cant_coins).to eq(10) # Se espera que se reduzcan 150 monedas

        # respuesta JSON sea la esperada y contenga dos opciones incorrectas

        json_response = JSON.parse(last_response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['removed_options'].size).to eq(2)

        # IDs de las opciones incorrectas
        incorrect_ids = [incorrect_option1.id, incorrect_option2.id, incorrect_option3.id]

        expect(json_response['removed_options']).to all(be_in(incorrect_ids))

        # Verifica que las opciones eliminadas sean incorrectas
        json_response['removed_options'].each do |id|
          option = Option.find(id)
          expect(option.correct).to be(false)
        end
      end
    end

    context 'when the user does not have enough coins' do
      # No puede usar el comodin
      it 'does not reduce the coins and does not return success' do
        # Actualiza las monedas del usuario para que no tenga suficientes y probar
        user.update(cant_coins: 50)
        request_body = { user_id: user.id, question_id: question.id }.to_json
        post '/use_50_50', request_body, { 'CONTENT_TYPE' => 'application/json' }
        expect(user.reload.cant_coins).to eq(50) # Las monedas deben permanecer igual
      end
    end
  end

  describe 'POST /inmunity' do
    let!(:user) { User.create(username: 'testuser', password: 'password123', cant_coins: 250) }

    before do
      env 'rack.session', { username: user.username }
    end

    context 'when the user has enough coins' do
      it 'reduces the user coins and returns success status' do
        request_body = { user_id: user.id }.to_json

        post '/inmunity', request_body, { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.content_type).to eq('application/json')
        expect(last_response.status).to eq(200)
        updated_user = User.find(user.id)
        expect(updated_user.reload.cant_coins).to eq(50) # Se espera que se reduzcan 200 monedas

        # Respuesta JSON sea la esperada
        json_response = JSON.parse(last_response.body)
        expect(json_response).to eq({ 'status' => 'success' })
      end
    end

    context 'when the user does not have enough coins' do
      it 'does not reduce the coins and does not return success' do
        user.update(cant_coins: 50)
        request_body = { user_id: user.id }.to_json
        post '/inmunity', request_body, { 'CONTENT_TYPE' => 'application/json' }
        expect(user.reload.cant_coins).to eq(50) # Las monedas deben permanecer igual
      end
    end
  end
end
