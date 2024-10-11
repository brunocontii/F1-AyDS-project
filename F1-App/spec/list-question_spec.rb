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

    describe 'GET /profile/view-question-data' do
        context 'when user is logged in' do
            let(:user) do
                User.create(
                    username: 'testuser',
                    password: 'testpassword',
                    cant_life: 3,
                    cant_coins: 0
                )
            end

            let(:profile) do
                Profile.create(
                    name: 'testname',
                    lastName: 'testLastName',
                    description: 'testDescription',
                    age: 21,
                    profile_picture: '/profile_pictures/charles-leclerc-2024.png',
                    user_id: user.id
                )
            end

            before do
                env 'rack.session', { username: user.username }
                profile

            end

            it 'renders the add question page' do
                get '/profile/view-question-data'
                expect(last_response).to be_ok
                expect(last_response.body).to include('List Question')
            end


            it 'shows correct questions when view_type is correct' do
                Question.create!(name_question: 'Question 1', level: 'easy', theme: 'pilot' , correct: 5, incorrect: 2)
                Question.create!(name_question: 'Question 2', level: 'normal', theme: 'pilot' , correct: 10, incorrect: 1)
          
                get '/profile/view-question-data', view_type: 'correct', limit: 1
                expect(last_response).to be_ok
                expect(last_response.body).to include('Question 2') # Asegúrate de que esta pregunta se incluya
                expect(last_response.body).not_to include('Question 1')
            end
      
            it 'shows incorrect questions when view_type is incorrect' do
                Question.create(name_question: 'Question 1', level: 'easy', theme: 'pilot' , correct: 5, incorrect: 10)
                Question.create(name_question: 'Question 2', level: 'difficult', theme: 'pilot' , correct: 3, incorrect: 20)
      
                get '/profile/view-question-data', view_type: 'incorrect', limit: 1
                expect(last_response).to be_ok
                expect(last_response.body).to include('Question 2')
                expect(last_response.body).not_to include('Question 1')
            end
      
            it 'limits the number of questions based on the limit parameter' do
                Question.create(name_question: 'Question 1', level: 'easy', theme: 'pilot' , correct: 1, incorrect: 1)
                Question.create(name_question: 'Question 2', level: 'impossible', theme: 'pilot' , correct: 2, incorrect: 2)
      
                get '/profile/view-question-data', view_type: 'correct', limit: 1
                expect(last_response.body).to include('Question 2')
                expect(last_response.body).not_to include('Question 1')
            end
        end

        context 'when user is not logged in' do
            it 'renders to the home page' do
                get '/profile/add-question'
                expect(last_response).to be_redirect
                follow_redirect!
                expect(last_request.path).to eq('/')
            end
        end
    end

end