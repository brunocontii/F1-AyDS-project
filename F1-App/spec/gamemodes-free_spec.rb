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

  describe 'GET /gamemodes/free' do
    # Creaciones de elementos temporales a utilizar
    let!(:user) { User.create(username: 'testuser', password: 'password123', cant_life: 3, cant_coins: 0) }
    let!(:question) { Question.create(name_question: 'Sample Question', level: 'easy', theme: 'free') }
    let!(:correct_option) { Option.create(name_option: 'Correct Option', question_id: question.id, correct: true) }
    let!(:incorrect_option) do
      Option.create(name_option: 'Incorrect Option 1', question_id: question.id, correct: false)
    end

    before do
      env 'rack.session', { username: user.username }
    end

    # Cuando el usuario no tiene vidas tiene que redireccionar a /gamemodes
    context 'when the user has no lives left' do
      before do
        user.update(cant_life: 0)
      end

      it 'redirects to /gamemodes with a message' do
        get '/gamemodes/free'
        expect(last_request.env['rack.session'][:message]).to eq('You have 0 lives. Please wait for lives to regenerate.')
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/gamemodes')
      end
    end

    # Cuando el modo es reseteado tiene que eliminar todas las preguntas anteriores y reiniciar el flag de reset
    # Simula que cree el una respuesta que resetea todo y se fija que dicha respuesta este vacia que es lo que tendria que pasar
    context 'when the mode is reset' do
      let!(:answered_question) do
        Answer.create(question_id: question.id, user_id: user.id, option_id: correct_option.id)
      end
      before do
        env 'rack.session', { username: user.username, reset_free_mode: true }
        get '/gamemodes/free'
      end

      it 'deletes previous answers and resets the reset_free_mode flag' do
        expect(Answer.where(id: answered_question.id)).to be_empty
        # espera que sea false el reseteo ya que ya reseteed
        expect(last_request.env['rack.session'][:reset_free_mode]).to be_falsey
      end
    end

    # Cuando hay respuesta no contestadas en la dificultad actual las pone en la cola para responder
    context 'when there are unanswered questions in the current difficulty' do
      before do
        get '/gamemodes/free'
      end

      it 'assigns an unanswered question to @question' do
        expect(last_response.body).to include('Sample Question')
      end
    end

    # Cuando se contestan todas las preguntas de la dificultad 'easy' se pasa a 'normal'
    context 'when the user has answered all questions in the easy difficulty' do
      let!(:easy_question) { Question.create(name_question: 'Easy Question', level: 'easy', theme: 'free') }

      before do
        # Simula que el usuario ha respondido todas las preguntas de dificultad 'easy'
        Answer.create(user: user, question: easy_question, option: correct_option)
        Question.where(level: 'easy', theme: 'free').each do |question|
          Answer.create(user: user, question: question, option: correct_option)
        end

        env 'rack.session',
            { username: user.username, free_mode_difficulty: 'easy',
              answered_free_questions: Question.where(level: 'easy', theme: 'free').pluck(:id) }
        get '/gamemodes/free'
      end

      it 'increases the difficulty to normal and shows the appropriate message' do
        expect(last_request.env['rack.session'][:free_mode_difficulty]).to eq('normal')
        expect(last_request.env['rack.session'][:message]).to eq("You've answered all the easy questions. Now the medium questions will appear.")
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/gamemodes/free')
      end
    end

    # Cuando se contestan todas las preguntas de la dificultad 'normal' se pasa a 'difficult'
    context 'when the user has answered all questions in the normal difficulty' do
      let!(:normal_question) { Question.create(name_question: 'Normal Question', level: 'normal', theme: 'free') }

      before do
        # Simula que el usuario ha respondido todas las preguntas de dificultad 'normal'
        Question.where(level: 'normal', theme: 'free').each do |question|
          Answer.create(user: user, question: question, option: correct_option)
        end

        env 'rack.session',
            { username: user.username, free_mode_difficulty: 'normal',
              answered_free_questions: Question.where(level: 'normal', theme: 'free').pluck(:id) }
        get '/gamemodes/free'
      end

      it 'increases the difficulty to difficult and shows the appropriate message' do
        expect(last_request.env['rack.session'][:free_mode_difficulty]).to eq('difficult')
        expect(last_request.env['rack.session'][:message]).to eq("You've answered all the medium questions. Now the hard questions will appear.")
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/gamemodes/free')
      end
    end

    # Cuando se contestan todas las preguntas de la dificultad 'difficult' se pasa a 'impossible'
    context 'when the user has answered all questions in the difficult difficulty' do
      let!(:difficult_question) do
        Question.create(name_question: 'Difficult Question', level: 'difficult', theme: 'free')
      end

      before do
        # Simula que el usuario ha respondido todas las preguntas de dificultad 'difficult'
        Question.where(level: 'difficult', theme: 'free').each do |question|
          Answer.create(user: user, question: question, option: correct_option)
        end

        env 'rack.session',
            { username: user.username, free_mode_difficulty: 'difficult',
              answered_free_questions: Question.where(level: 'difficult', theme: 'free').pluck(:id) }
        get '/gamemodes/free'
      end

      it 'increases the difficulty to impossible and shows the appropriate message' do
        expect(last_request.env['rack.session'][:free_mode_difficulty]).to eq('impossible')
        expect(last_request.env['rack.session'][:message]).to eq("You've answered all the hard questions. Now the impossible questions will appear.")
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/gamemodes/free')
      end
    end

    # Cuando se contestan todas las preguntas de la dificultad 'impossible' se resetea el modo free
    context 'when the user completes the impossible level' do
      let!(:impossible_question) do
        Question.create(name_question: 'Impossible Question', level: 'impossible', theme: 'free')
      end

      before do
        # Simula que el usuario ha respondido todas las preguntas de dificultad 'impossible'
        Question.where(level: 'impossible', theme: 'free').each do |question|
          Answer.create(user: user, question: question, option: correct_option)
        end

        env 'rack.session',
            { username: user.username, free_mode_difficulty: 'impossible',
              answered_free_questions: Question.where(level: 'impossible', theme: 'free').pluck(:id) }
        get '/gamemodes/free'
      end

      it 'resets the difficulty to easy, resets answered questions, and shows the completion message' do
        expect(last_request.env['rack.session'][:free_mode_difficulty]).to eq('easy')
        expect(last_request.env['rack.session'][:answered_free_questions]).to be_empty
        expect(last_request.env['rack.session'][:message]).to eq("Congratulations! You've completed the Free Mode.")
        expect(last_request.env['rack.session'][:reset_free_mode]).to be_truthy
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/gamemodes')
      end
    end

    # aca agregar test para la linea que falta de cubrir en simplecov
  end

  describe 'POST /gamemodes/free' do
    # Preparando usuario y pregunta con sus respuestas
    let!(:user) { User.create(username: 'testuser', password: 'password123', cant_life: 3, cant_coins: 0) }
    let!(:question) { Question.create(name_question: 'Sample Question', level: 'easy', theme: 'free') }
    let!(:correct_option) { Option.create(name_option: 'Correct Answer', correct: true, question: question) }
    let!(:incorrect_option) { Option.create(name_option: 'Incorrect Answer', correct: false, question: question) }

    before do
      env 'rack.session', { username: user.username }
    end

    # Cuando el usuario no tiene vidas
    context 'when the user has no lives left' do
      it 'redirects to /gamemodes' do
        user.update(cant_life: 0)
        post '/gamemodes/free'

        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/gamemodes')
      end
    end

    # Cuando no tenemos más tiempo
    context 'when you dont have more time left' do
      # Y vida tiene una
      it 'reduces the users lives and redirects to /gamemodes if lives reaches 0' do
        user.update(cant_life: 1)
        post '/gamemodes/free', { timeout: 'true' }

        expect(user.reload.cant_life).to eq(0)
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/gamemodes')
      end

      # Y vida tiene mas de una
      it 'reduces the users lives and continues if lives are still remaining' do
        initial_lives = user.cant_life
        post '/gamemodes/free', { timeout: 'true' }

        expect(user.reload.cant_life).to eq(initial_lives - 1)
        expect(last_response).to be_redirect
        expect(last_response.location).to include('/gamemodes/free')
        expect(last_request.env['rack.session'][:message]).to eq("Time's up! Incorrect!")
        expect(last_request.env['rack.session'][:color]).to eq('red')
      end
    end

    # Cuando una opción incorrecta es seleccionada
    context 'when an incorrect option is selected' do
      # Y vida tiene una
      it 'reduces the users lives and redirects if lives reached 0' do
        user.update(cant_life: 1)
        post '/gamemodes/free', { option_id: incorrect_option.id }

        expect(user.reload.cant_life).to eq(0)
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/gamemodes')
      end

      # Y vida tiene mas de una
      it 'reduces the users lives and continues if lives are still remaining' do
        initial_lives = user.cant_life
        post '/gamemodes/free', { option_id: incorrect_option.id }

        expect(user.reload.cant_life).to eq(initial_lives - 1)
        expect(last_response).to be_redirect
        expect(last_response.location).to include('/gamemodes/free')
        expect(last_request.env['rack.session'][:message]).to eq('Incorrect!')
        expect(last_request.env['rack.session'][:color]).to eq('red')
      end

      # Pero tiene la inmunidad
      it 'activates inmunity and does not reduce life' do
        user.update(cant_life: 1)
        env 'rack.session', { username: user.username, inmunity: true }
        post '/gamemodes/free', { option_id: incorrect_option.id }
        expect(user.reload.cant_life).to eq(1)
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/gamemodes/free')
      end
    end

    # Cuando una opción correcta es seleccionada
    context 'when a correct option is selected' do
      # Gana 10
      it 'increments the users coins and redirects to /gamemodes/free' do
        post '/gamemodes/free', { option_id: correct_option.id }

        expect(user.reload.cant_coins).to eq(10)
        expect(last_response).to be_redirect
        expect(last_response.location).to include('/gamemodes/free')
        expect(last_request.env['rack.session'][:message]).to eq('Correct! Well done.')
        expect(last_request.env['rack.session'][:color]).to eq('green')
      end
    end

    # Cuando el usuario selecciona un id invalido
    context 'when the user selects an invalid option id' do
      # Mostramos mensaje de error
      it 'displays an error message and redirects to /gamemodes' do
        post '/gamemodes/free', { option_id: 0 }
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/gamemodes')
      end

      # Pero tiene la inmunidad
      it 'activates inmunity and does not reduce life' do
        user.update(cant_life: 1)
        env 'rack.session', { username: user.username, inmunity: true }
        post '/gamemodes/free', { option_id: 0 }
        expect(user.reload.cant_life).to eq(1)
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/gamemodes/free')
      end
    end
  end
end
