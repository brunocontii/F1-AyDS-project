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

  describe 'GET /gamemodes/progressive' do
    context 'when user is loggen in' do
      let(:user) do
        User.create(
          username: 'testuser',
          password: 'testpassword',
          cant_life: 2,
          cant_coins: 130
        )
      end

      before do
        env 'rack.session', { username: user.username }
      end

      it 'returns JSON with lives when requested via AJAX' do
        env 'rack.session', { username: user.username }
        get '/gamemodes/progressive', {}, 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest'
        expected_response = { lives: user.cant_life }.to_json

        expect(last_response).to be_ok
        expect(last_response.content_type).to eq('application/json')
        expect(last_response.body).to eq(expected_response)
      end

      it 'renders gamemodes template when not requested via AJAX' do
        get '/gamemodes/progressive'
        expect(last_response.body).to include(user.cant_life.to_s)
        expect(last_response.body).to include(user.cant_coins.to_s)
        expect(last_response.body).to include('Progressive')
      end
    end

    context 'when user is not logged in' do
      it 'redirects to home page' do
        get '/gamemodes/progressive'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/')
      end
    end
  end

  describe 'GET /gamemodes/progressive/:mode' do
    %w[pilot team career circuit].each do |mode|
      context "when mode is #{mode}" do
        let(:user) do
          User.create(
            username: 'testuser',
            password: 'testpassword',
            cant_life: 3,
            cant_coins: 220
          )
        end

        before do
          env 'rack.session', { username: user.username }
          # Preparando pregunta y respuestas para testear
          @question = Question.create(name_question: 'Sample Question', level: 'easy', theme: mode)
          @correct_option = Option.create(name_option: 'Correct Option', question_id: @question.id,
                                          correct: true)
          @incorrect_option1 = Option.create(name_option: 'Incorrect Option 1', question_id: @question.id,
                                             correct: false)
          @incorrect_option2 = Option.create(name_option: 'Incorrect Option 2', question_id: @question.id,
                                             correct: false)
          @incorrect_option3 = Option.create(name_option: 'Incorrect Option 3', question_id: @question.id,
                                             correct: false)
        end

        # Si la pregunta se muestra, que se muestre tanto la pregunta
        # como la opcion correcta y las 3 incorrectas.
        it 'displays a question and its options if available' do
          get "/gamemodes/progressive/#{mode}"
          expect(last_response).to be_ok
          expect(last_response.body).to include(@question.name_question)
          expect(last_response.body).to include(@correct_option.name_option)
          expect(last_response.body).to include(@incorrect_option1.name_option)
          expect(last_response.body).to include(@incorrect_option2.name_option)
          expect(last_response.body).to include(@incorrect_option3.name_option)
        end

        # Si no hay preguntas ya disponibles porque fueron contestadas todas correctamente
        # se borrarian todas y me redirecciono a gamemodes.
        it 'redirects to /gamemodes if no questions available' do
          Option.delete_all # Se elimina antes de question ya que sino no se podria, son dependientes
          Question.delete_all # se hace por las dudas que este cargada la bdd con algo externo a este test
          get "/gamemodes/progressive/#{mode}"
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/gamemodes')
        end

        # Si no hay vidas, tendrian que estar en 0 y me redirecciono a /gamemodes
        it 'redirects to /gamemodes if no lives available' do
          user.update(cant_life: 0)
          get "/gamemodes/progressive/#{mode}"
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/gamemodes')
        end
      end
    end
  end

  describe 'POST /gamemodes/progressive/:mode' do
    let(:user) { User.create(username: 'testuser', password: 'testpassword', cant_life: 3, cant_coins: 0) }
    let(:question) { Question.create(name_question: 'What is Ruby?', level: 'easy', theme: mode) }
    let(:correct_option) do
      Option.create(name_option: 'A programming language', question_id: question.id, correct: true)
    end
    let(:incorrect_option) { Option.create(name_option: 'A gemstone', question_id: question.id, correct: false) }

    before do
      env 'rack.session', { username: user.username }
    end

    # Parametrizacion para todos los modos de juego
    shared_examples 'progressive mode' do |mode|
      let(:mode) { mode }

      # Cuando el tiempo para responder se termino
      context 'when time runs out' do
        # Y el usuario se quedo sin vidas
        it 'reduces life and redirects to /gamemodes when no lives left' do
          user.update(cant_life: 1)
          user.reload
          post "/gamemodes/progressive/#{mode}", { timeout: 'true' }
          expect(user.reload.cant_life).to eq(0)
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/gamemodes')
        end

        # Todavia le quedan vidas al usuario
        it 'reduces life and reloads the mode when lives remain' do
          initial_lives = user.cant_life
          post "/gamemodes/progressive/#{mode}", { timeout: 'true' }
          expect(user.reload.cant_life).to eq(initial_lives - 1)
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq("/gamemodes/progressive/#{mode}")
        end
      end

      # Cuando el usuario responde correctamente
      context 'when the user selects a correct option' do
        # Incrementamos monedas y cargamos la pregunta que sigue
        it 'increments coins and reloads the mode' do
          post "/gamemodes/progressive/#{mode}", { option_id: correct_option.id }
          expect(user.reload.cant_coins).to eq(10)
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq("/gamemodes/progressive/#{mode}")
        end
      end

      # Cuando el usuario responde incorrectamente
      context 'when the user selects an incorrect option' do
        # Y se quedo sin vidas para jugar
        it 'reduces life and redirects to /gamemodes when no lives left' do
          user.update(cant_life: 1)
          post "/gamemodes/progressive/#{mode}", { option_id: incorrect_option.id }
          expect(user.reload.cant_life).to eq(0)
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/gamemodes')
        end

        # Todavia tiene vidas para jugar
        it 'reduces life and reloads the mode when lives remain' do
          initial_lives = user.cant_life
          post "/gamemodes/progressive/#{mode}", { option_id: incorrect_option.id }
          expect(user.reload.cant_life).to eq(initial_lives - 1)
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq("/gamemodes/progressive/#{mode}")
        end

        # Tiene la inmunidad activada
        it 'activates inmunity and does not reduce life' do
          user.update(cant_life: 1)
          env 'rack.session', { username: user.username, inmunity: true }
          post "/gamemodes/progressive/#{mode}", { option_id: incorrect_option.id }
          expect(user.reload.cant_life).to eq(1)
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq("/gamemodes/progressive/#{mode}")
        end
      end

      # Cuando el usuario selecciona un id invalido
      context 'when the user selects an invalid option id' do
        # Mostramos mensaje de error
        it 'displays an error message and redirects to /gamemodes' do
          post "/gamemodes/progressive/#{mode}", { option_id: 0 }
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/gamemodes')
        end

        # Pero tiene la inmunidad
        it 'activates inmunity and does not reduce life' do
          user.update(cant_life: 1)
          env 'rack.session', { username: user.username, inmunity: true }
          post "/gamemodes/progressive/#{mode}", { option_id: 0 }
          expect(user.reload.cant_life).to eq(1)
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq("/gamemodes/progressive/#{mode}")
        end
      end

      # Cuando el usuario no tiene mas vidas
      context 'when the user has no lives left' do
        it 'does not allow playing and redirects to /gamemodes' do
          user.update(cant_life: 0)
          post "/gamemodes/progressive/#{mode}"
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/gamemodes')
        end
      end
    end

    # Parametrizacion
    %w[pilot career team circuit].each do |mode|
      include_examples 'progressive mode', mode
    end
  end
end
