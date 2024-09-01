ENV['APP_ENV'] = 'test'

require_relative '../app.rb'
require 'rspec'
require 'rack/test'

RSpec.describe 'The App' do
    include Rack::Test::Methods

    def app
        # Sinatra::Appplication
        App
    end

    describe 'GET /gamemodes/free' do
      let!(:user) { User.create(username: 'testuser', password: 'password123', cant_life: 2, cant_coins: 0) }
      let!(:easy_question) { Question.create(name_question: 'Easy Question', level: 'easy', theme: 'free') }
      let!(:normal_question) { Question.create(name_question: 'Normal Question', level: 'normal', theme: 'free') }
      let!(:difficult_question) { Question.create(name_question: 'Difficult Question', level: 'difficult', theme: 'free') }
      let!(:correct_option) { Option.create(name_option:'Correct Answer', correct: true, question: easy_question) }
      let!(:incorrect_option) { Option.create(name_option:'Incorrect Answer', correct: false, question: easy_question) }

      before do
          env 'rack.session', { username: user.username }
      end

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

      #context 'when reset_free_mode is set' do
      #    before do
      #        env 'rack.session', { reset_free_mode: true, #answered_free_questions: [easy_question.id] }
      #    end
      #
      #    it 'resets the free mode and deletes previous answers' do
      #        get '/gamemodes/free'
      #        expect(last_request.env['rack.session'][:answered_free_questions]).to be_empty
      #        expect(last_request.env['rack.session'][:reset_free_mode]).to be_nil
      #        expect(last_response).to be_ok
      #    end
      #end

      #context 'when there are unanswered questions' do
      #    it 'assigns an unanswered question to @question' do
      #        get '/gamemodes/free'
      #        expect(last_response).to be_ok
      #        expect(assigns(:question)).to eq(easy_question)
      #    end
      #end

      #context 'when there are NO unanswered question but incorrect ones' do
      #    before do
      #        Answer.create(question_id: easy_question.id, user_id: user.id, option_id: correct_option.id)
      #        last_request.env['rack.session'][:answered_free_questions] = [easy_question.id]
      #    end
      #
      #    it 'assigns an incorrectly answered question to @question' do
      #        get '/gamemodes/free'
      #        expect(last_response).to be_ok
      #        expect(assigns(:question)).to eq(easy_question)
      #    end
      #end

      #context 'when all question are answered' do
      #    before do
      #        Answer.create(question_id: easy_question.id, user_id: user.id, option_id: correct_option.id)
      #        env 'rack.session', { answered_free_questions: [easy_question.id], free_mode_difficulty: 'normal', unanswered_questions: [] }
      #    end

      #    it 'updates the difficulty and provides a new question' do
      #        get '/gamemodes/free'
      #        expect(last_request.env['rack.session'][:free_mode_difficulty]).to eq('difficult')
      #        expect(assigns(:question)).to eq(difficult_question)
      #    end
      #end

      #context 'when all questions are answered and the mode needs to reset' do
      #    before do
      #        Answer.create(question_id: easy_question.id, user_id: user.id, option_id: correct_option.id)
      #        env 'rack.session', { answered_free_questions: [easy_question.id], free_mode_difficulty: 'impossible' }
      #        Question.create(name_question: 'Another Question', level: 'easy', theme: 'free')
      #    end
      #
      #    it 'resets the mode and redirects appropriately' do
      #        get '/gamemodes/free'
      #        expect(last_request.env['rack.session'][:answered_free_questions]).to be_empty
      #        expect(last_request.env['rack.session'][:free_mode_difficulty]).to eq('easy')
      #        expect(last_response).to be_redirect
      #        follow_redirect!
      #        expect(last_request.path).to eq('/gamemodes')
      #    end
      #end
    end

    describe 'POST /gamemodes/free' do
      # Preparando usuario y pregunta con sus respuestas
      let!(:user) { User.create(username: 'testuser', password: 'password123', cant_life: 3, cant_coins: 0) }
      let!(:question) { Question.create(name_question: 'Sample Question', level: 'easy', theme: 'free') }
      let!(:correct_option) { Option.create(name_option:'Correct Answer', correct: true, question: question) }
      let!(:incorrect_option) { Option.create(name_option:'Incorrect Answer', correct: false, question: question) }

      before do
          env 'rack.session', { username: user.username }
      end

      # Cuando no tenemos más tiempo
      context 'when you dont have more time left' do
          # Y vida tiene una
          it 'reduces the users lives and redirects to /gamemodes if lives reaches 0' do
              user.update(cant_life: 1)
              post '/gamemodes/free', { timeout: 'true' }

              expect(user.reload.cant_life).to eq(0)
              expect(last_response).to be_redirect
              expect(last_response.location).to include('/gamemodes')
              expect(last_request.env['rack.session'][:message]).to eq("You have 0 lives. Please wait for lives to regenerate.")
              expect(last_request.env['rack.session'][:color]).to eq("red")
          end

          # Y vida tiene mas de una
          it 'reduces the users lives and continues if lives are still remaining' do
              initial_lives = user.cant_life
              post '/gamemodes/free', { timeout: 'true' }

              expect(user.reload.cant_life).to eq(initial_lives - 1)
              expect(last_response).to be_redirect
              expect(last_response.location).to include('/gamemodes/free')
              expect(last_request.env['rack.session'][:message]).to eq("Time's up! Incorrect!")
              expect(last_request.env['rack.session'][:color]).to eq("red")
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
              expect(last_response.location).to include('/gamemodes')
              expect(last_request.env['rack.session'][:message]).to eq("You have 0 lives. Please wait for lives to regenerate.")
              expect(last_request.env['rack.session'][:color]).to eq("red")
          end

          # Y vida tiene mas de una
          it 'reduces the users lives and continues if lives are still remaining' do
              initial_lives = user.cant_life
              post '/gamemodes/free', { option_id: incorrect_option.id }

              expect(user.reload.cant_life).to eq(initial_lives-1)
              expect(last_response).to be_redirect
              expect(last_response.location).to include('/gamemodes/free')
              expect(last_request.env['rack.session'][:message]).to eq("Incorrect!")
              expect(last_request.env['rack.session'][:color]).to eq("red")
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
              expect(last_request.env['rack.session'][:message]).to eq("Correct! Well done.")
              expect(last_request.env['rack.session'][:color]).to eq("green")
          end
      end
    end

end
