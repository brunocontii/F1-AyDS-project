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

    describe 'POST /register' do
        context 'with valid details' do
            it 'registers the user and redirects to /gamemodes' do
                post '/register', { username: 'newuser', password: 'password', repeat_password: 'password' }

                expect(last_response).to be_redirect
                follow_redirect!
                expect(last_request.path).to eq('/gamemodes')
                expect(User.find_by(username: 'newuser')).not_to be_nil
            end
        end

        context 'with existing username' do
            let!(:existing_user) { User.create(username: 'existinguser', password: 'password') }

            it 'renders the register page with an error' do
                post '/register', { username: 'existinguser', password: 'password', repeat_password: 'password' }

                expect(last_response).to be_ok
                expect(last_response.body).to include('Username already exist')
            end
        end

        context 'with non-matching passwords' do
            it 'renders the register page with an error' do
                post '/register', { username: 'newuser', password: 'password', repeat_password: 'wrongpassword' }

                expect(last_response).to be_ok
                expect(last_response.body).to include('Passwords are different')
            end
        end
    end

    
end
