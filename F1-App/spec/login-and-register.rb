ENV['APP_ENV'] = 'test'

require_relative '../app'
require 'rspec'
require 'rack/test'

RSpec.describe 'The App' do
    include Rack::Test::Methods

    def app
        App
    end

    describe 'POST /login' do
        context 'with valid credentials' do
            let!(:user) { User.create(username: 'testuser', password: 'password') }

            it 'logs the user in and redirects to /gamemodes' do
                post '/login', { username: 'testuser', password: 'password' }

                expect(last_response).to be_redirect
                follow_redirect!
                expect(last_request.path).to eq('/gamemodes')
                expect(last_response.body).to include('current_user')
            end
        end

        context 'with invalid credentials' do
            it 'renders the login page with an error' do
                post '/login', { username: 'wronguser', password: 'wrongpassword' }

                expect(last_response).to be_ok
                expect(last_response.body).to include('Invalid username or password')
            end
        end
    end

    describe 'GET /register' do
        it 'loads the register page with profile picture options' do
            get '/register'

            expect(last_response).to be_ok
            expect(last_response.body).to include('Choose a profile picture')
            profile_pictures = Dir.glob(File.join(app.settings.public_folder, 'profile_pictures', '*')).map { |path| File.basename(path) }

            # Verificar que cada imagen de perfil está presente en la respuesta
            profile_pictures.each do |profile_picture|
                expect(last_response.body).to include(profile_picture)
            end
        end
    end

    describe 'POST /register' do
        context 'with valid details' do
            it 'registers the user and redirects to /gamemodes' do
                post '/register', { 
                    username: 'newuser', 
                    password: 'password', 
                    repeat_password: 'password',
                    name: 'John',
                    lastname: 'Doe',
                    description: 'A new user',
                    age: '25',
                    profile_pic: 'profile1.png'
                }

                expect(last_response).to be_redirect
                follow_redirect!
                expect(last_request.path).to eq('/gamemodes')
                expect(User.find_by(username: 'newuser')).not_to be_nil
                expect(Profile.find_by(user_id: User.find_by(username: 'newuser').id)).not_to be_nil
            end
        end

        context 'with existing username' do
            let!(:existing_user) { User.create(username: 'existinguser', password: 'password') }

            it 'renders the register page with an error' do
                post '/register', { 
                    username: 'existinguser', 
                    password: 'password', 
                    repeat_password: 'password',
                    name: 'Jane',
                    lastname: 'Doe',
                    description: 'An existing user',
                    age: '30',
                    profile_pic: 'profile2.png'
                }

                expect(last_response).to be_ok
                expect(last_response.body).to include('Username already exist')
            end
        end

        context 'with non-matching passwords' do
            it 'renders the register page with an error' do
                post '/register', { 
                    username: 'newuser', 
                    password: 'password', 
                    repeat_password: 'wrongpassword',
                    name: 'John',
                    lastname: 'Doe',
                    description: 'A new user',
                    age: '25',
                    profile_pic: 'profile1.png'
                }

                expect(last_response).to be_ok
                expect(last_response.body).to include('Passwords are different')
            end
        end
    end
end
