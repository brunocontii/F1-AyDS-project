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

  describe 'GET /profile/add-question' do
    context 'when user is logged in' do
      let(:user) do
        User.create(
          username: 'testuser',
          password: 'testpassword',
          cant_life: 3,
          cant_coins: 0,
          admin: true
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
        get '/profile/add-question'
        expect(last_response).to be_ok
        expect(last_response.body).to include('Add Question')
      end
    end

    context 'when user is logged in but is not admin' do
      let(:user) do
        User.create(
          username: 'testuser',
          password: 'testpassword',
          cant_life: 3,
          cant_coins: 0,
          admin: false
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

      it 'renders to the profile page' do
        get '/profile/add-question'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/profile')
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

  describe 'POST /profile/add-question' do
    context 'when user is logged in' do
      let(:user) do
        User.create(
          username: 'testuser',
          password: 'testpassword',
          cant_life: 3,
          cant_coins: 0,
          admin: true
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

      context 'when adding a text question' do
        it 'creates a new text question and options' do
          post '/profile/add-question', {
            question_type: 'text',
            question_text: 'testquestion',
            difficulty: 'easy',
            theme: 'team',
            option1: 'op1',
            option2: 'op2',
            option3: 'op3',
            option4: 'op4',
            correct_answer: 'option1'
          }
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/profile/add-question')
          expect(Question.find_by(name_question: 'testquestion')).to_not be_nil
        end

        it 'does not allow duplicate questions' do
          Question.create(
            name_question: 'duplicate question',
            level: 'easy',
            theme: 'team'
          )

          post '/profile/add-question', {
            question_type: 'text',
            question_text: 'duplicate question',
            difficulty: 'easy',
            theme: 'team',
            option1: 'op1',
            option2: 'op2',
            option3: 'op3',
            option4: 'op4',
            correct_answer: 'option1'
          }

          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/profile/add-question')
          expect(last_response.body).to include('The question already exists in the database.')
        end
      end

      context 'when adding an image question with valid format' do
        it 'creates a new image question' do
          image_path = File.join('public', 'grandprix', 'imagen1.png')
          image_file = Rack::Test::UploadedFile.new(image_path, 'image/png')

          post '/profile/add-question', {
            question_type: 'image',
            question_image: image_file,
            difficulty: 'easy',
            theme: 'team',
            option1: 'op1',
            option2: 'op2',
            option3: 'op3',
            option4: 'op4',
            correct_answer: 'option1'
          }

          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/profile/add-question')
          expect(Question.find_by(image_question: '/grandprix/imagen1.png')).to_not be_nil
        end
      end

      context 'when adding an image question with invalid format' do
        it 'rejects the invalei image format' do
          invalid_image_path = File.join('spec', 'gamemodes_spec.rb')
          invalid_image = Rack::Test::UploadedFile.new(invalid_image_path, 'application/x-ruby')

          post '/profile/add-question', {
            question_type: 'image',
            question_image: invalid_image,
            difficulty: 'easy',
            theme: 'team',
            option1: 'op1',
            option2: 'op2',
            option3: 'op3',
            option4: 'op4',
            correct_answer: 'option1'
          }

          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/profile/add-question')
          expect(last_response.body).to include('Invalid image format. Only JPG, JPEG and PNG are allowed.')
        end
      end

      context 'when adding an image question without uploading an image' do
        it 'rejects the request and shows an error' do
          post '/profile/add-question', {
            question_type: 'image',
            difficulty: 'easy',
            theme: 'team',
            option1: 'op1',
            option2: 'op2',
            option3: 'op3',
            option4: 'op4',
            correct_answer: 'option1'
          }

          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/profile/add-question')
          expect(last_response.body).to include('Please upload an image.')
        end
      end

      context 'when saving the question fails for any reason' do
        it 'shows an error message' do
          allow_any_instance_of(Question).to receive(:save).and_return(false)

          post '/profile/add-question', {
            question_type: 'text',
            question_text: 'test question',
            difficulty: 'easy',
            theme: 'team',
            option1: 'op1',
            option2: 'op2',
            option3: 'op3',
            option4: 'op4',
            correct_answer: 'option1'
          }

          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/profile/add-question')
          expect(last_response.body).to include('There was an error adding the question:')
        end
      end
    end
  end
end
