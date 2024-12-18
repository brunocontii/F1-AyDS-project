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

  describe 'GET /profile (logged in user)' do
    let(:user) do
      User.create(username: 'testuser', password: 'testpassword', cant_life: 3, cant_coins: 0)
    end

    let(:profile) do
      Profile.create(
        name: 'testname', lastName: 'testlastName', description: 'testdescription', age: 25,
        profile_picture: '/profile_pictures/charles-leclerc-2024.png', user_id: user.id
      )
    end

    before do
      env 'rack.session', { username: user.username }
      profile
    end

    it 'returns JSON with lives when requested via AJAX' do
      get '/profile', {}, 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest'
      expect(last_response.content_type).to eq('application/json')
      expect(last_response.body).to eq({ lives: user.cant_life }.to_json)
    end
  end

  describe 'calculate_progress' do
    let(:user) { User.create(username: 'testuser', password: 'testpassword', cant_life: 3, cant_coins: 0) }
    let(:profile) do
      Profile.create(
        name: 'testname', lastName: 'testlastName', description: 'testdescription', age: 25,
        profile_picture: '/profile_pictures/charles-leclerc-2024.png', user_id: user.id
      )
    end

    before do
      env 'rack.session', { username: user.username }
      profile
    end

    context 'when there is a theme and there are correct answers' do
      let!(:question) { Question.create(name_question: 'Sample Question', level: 'easy', theme: 'pilot') }
      let!(:option) { Option.create(name_option: 'Correct Option', question_id: question.id, correct: true) }
      # suponiendo que la opción es correcta
      let!(:answer) do
        Answer.create(question_id: question.id, user_id: user.id, option_id: option.id)
      end
      it 'calculates progress with correct answers for the specified theme' do
        get '/profile'
        expect(last_response.body).to include('100') # Ajusta según cómo se muestra @count_pi en la vista
      end
    end
  end

  describe 'GET /profile (not logged in user)' do
    it 'redirects to home page' do
      get '/profile'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/')
    end
  end

  describe 'POST /profile/picture (logged in user)' do
    let(:user) do
      User.create(username: 'testuser', password: 'testpassword', cant_life: 3, cant_coins: 0)
    end

    let(:profile) do
      Profile.create(
        name: 'testname', lastName: 'testlastName', description: 'testdescription', age: 25,
        profile_picture: '/profile_pictures/charles-leclerc-2024.png', user_id: user.id
      )
    end

    # Guardamos todas las fotos
    let(:profile_picture_file) { Dir.glob('public/profile_pictures/*.png').sample }

    before do
      env 'rack.session', { username: user.username }
      profile
    end

    it 'updates the profile picture' do
      # Post con la nueva foto de perfil
      post '/profile/picture',
           profile_picture: "/public/profile_pictures/#{File.basename(profile_picture_file)}"
      updated_profile = Profile.find_by(user_id: user.id)
      # Una vez que se actualizo la foto de perfil
      # chequeamos que sea la que se paso como parametro al post
      expect(updated_profile.profile_picture).to eq("/public/profile_pictures/#{File.basename(profile_picture_file)}")
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/profile')
    end
  end

  describe 'POST /profile/picture (not logged in user)' do
    it 'redirects to home page' do
      post '/profile/picture'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/')
    end
  end

  describe 'GET /profile/change-password (logged in user)' do
    let(:user) do
      User.create(username: 'testuser', password: 'testpassword', cant_life: 3, cant_coins: 0, total_points: 0)
    end

    let(:profile) do
      Profile.create(
        name: 'testname', lastName: 'testlastName', email: 'test@gmail.com', description: 'testdescription',
        age: 25, profile_picture: '/profile_pictures/charles-leclerc-2024.png', user_id: user.id
      )
    end

    before do
      env 'rack.session', { username: user.username }
      profile
    end

    # Render del formulario
    it 'renders the change password page' do
      get '/profile/change-password'
      expect(last_response).to be_ok
      expect(last_response.body).to include('<h3>Change Password</h3>')
    end
  end

  describe 'GET /profile/change-password (not logged in user)' do
    # Se lo redirecciona a "/"
    it 'redirects to the login page' do
      get '/profile/change-password'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/')
    end
  end

  # Test del POST de cambiar contraseña
  describe 'POST /profile/change_password' do
    let(:user) do
      User.create(username: 'testuser', password: 'testpassword', cant_life: 3, cant_coins: 0, total_points: 0)
    end

    let(:profile) do
      Profile.create(
        name: 'testname', lastName: 'testlastName', email: 'test@gmail.com', description: 'testdescription',
        age: 25, profile_picture: '/profile_pictures/charles-leclerc-2024.png', user_id: user.id
      )
    end

    before do
      env 'rack.session', { username: user.username }
      profile
    end

    # Cuando la contraseña actual es correcta, ademas la contraseña nueva es igual
    # a la repeticion de la contraseña nueva
    context 'when current password is correct and new passwords match' do
      # Se cambia la contraseña correctamente y se lo redirecciona
      it 'changes the password and redirects to profile' do
        post '/profile/change_password', {
          current_password: 'testpassword', new_password: 'newpassword', confirm_password: 'newpassword'
        }
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/profile')
      end
    end

    # Cuando la contraseña actual es incorrecta
    context 'when current password is incorrect' do
      # No puede cambiar la contraseña y se lo redirecciona
      it 'does not change the password and shows an error' do
        post '/profile/change_password', {
          current_password: 'wrongpassword', new_password: 'newpassword', confirm_password: 'newpassword'
        }
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/profile/change-password')
      end
    end

    # Cuando la contraseña nueva no es igual a la repeticion de la nueva contraseña
    context 'when new passwords do not match' do
      # No puede cambiar la contraseña y se lo redirecciona
      it 'does not change the password and shows an error' do
        post '/profile/change_password', {
          current_password: 'testpassword', new_password: 'newpassword', confirm_password: 'differentpassword'
        }
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/profile/change-password')
      end
    end
  end
end
