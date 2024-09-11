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

    describe 'GET /profile' do
      # Cuando el usuario esta logueado carga todo bien
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
                  lastName: 'testlastName',
                  description: 'testdescription',
                  age: 25,
                  profile_picture: '/profile_pictures/charles-leclerc-2024.png',
                  user_id: user.id
              )
          end

          before do
              env 'rack.session', { username: user.username }
              profile
          end

          it 'returns JSON with lives when requested via AJAX' do
              env 'rack.session', { username: user.username }
              get '/profile', {}, 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest'
              expect(last_response.content_type).to eq('application/json')
              expect(last_response.body).to eq({ lives: user.cant_life }.to_json)
          end
      end

      context 'when user is not logged in' do
          it 'redirects to home page' do
              get '/profile'
              expect(last_response).to be_redirect
              follow_redirect!
              expect(last_request.path).to eq('/')
          end
      end
  end

  describe 'POST /profile/picture' do
      # Cuando el usuario esta logueado
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
                  lastName: 'testlastName',
                  description: 'testdescription',
                  age: 25,
                  profile_picture: '/profile_pictures/charles-leclerc-2024.png',
                  user_id: user.id
              )
          end

          # Guardamos todas las fotos
          let(:profile_picture_file) { Dir.glob("public/profile_pictures/*.png").sample }

          before do
              env 'rack.session', { username: user.username }
              profile
          end

          it 'updates the profile picture' do
              # Post con la nueva foto de perfil
              post '/profile/picture', profile_picture: "/public/profile_pictures/#{File.basename(profile_picture_file)}"
              updated_profile = Profile.find_by(user_id: user.id)
              # Una vez que se actualizo la foto de perfil
              # chequeamos que sea la que se paso como parametro al post
              expect(updated_profile.profile_picture).to eq("/public/profile_pictures/#{File.basename(profile_picture_file)}")
              expect(last_response).to be_redirect
              follow_redirect!
              expect(last_request.path).to eq('/profile')
          end
      end

      # Cuando el usuario no esta logueado
      # se lo redirecciona a /
      context 'when user is not logged in' do
          it 'redirects to home page' do
              post '/profile/picture'
              expect(last_response).to be_redirect
              follow_redirect!
              expect(last_request.path).to eq('/')
          end
      end
  end

end