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

    # Test para verificar que la ruta GET /login va a la pagina de inicio de sesion correctamente.
    describe 'GET /login' do
        it 'renders the login page' do
            get '/login'
            expect(last_response).to be_ok
            expect(last_response.body).to include('Login')
        end
    end

    # Test para verificar el comportamiento de la ruta POST /login al iniciar sesion con credenciales tanto correctas como incorrectas.
    describe 'POST /login' do
        let!(:user) { User.create(username: 'testuser', password: 'password123') }

        it 'logs in with correct credentials' do
            post '/login', username: 'testuser', password: 'password123'
            expect(last_response).to be_redirect
            follow_redirect!
            expect(last_request.path).to eq('/gamemodes')
        end

        it 'fails to log in with incorrect credentials' do
            post '/login', username: 'testuser', password: 'wrongpassword'
            expect(last_response).to be_ok
            expect(last_response.body).to include('Invalid username or password.')
        end
    end

    # Test para verificar que la ruta GET /register va a la pagina de registro correctamente.
    describe 'GET /register' do
        it 'renders the register page' do
            get '/register'
            expect(last_response).to be_ok
            expect(last_response.body).to include('Register')
        end
    end

    # Test para verificar el comportamiento de la ruta POST /register al registrar usuario y sus 3 variantes
    # 1) si esta todo correcto, 2) si el usuario ya existe, 3) si las contraseñas de un usuario no coindicen.
    describe 'POST /register' do
        before do
            allow(Dir).to receive(:glob).and_return(['profile1.png', 'profile2.png'])
        end

        it 'registers a new user with valid details' do
            post '/register', {
                username: 'newuser',
                password: 'password123',
                repeat_password: 'password123',
                name: 'First',
                lastname: 'Last',
                description: 'A new user',
                age: '25',
                profile_pic: 'profile1.png'
            }
            expect(last_response).to be_redirect
            follow_redirect!
            expect(last_request.path).to eq('/gamemodes')
        end

        it 'fails to register if username already exists' do
            User.create(username: 'existinguser', password: 'password123')
            post '/register', {
                username: 'existinguser',
                password: 'password123',
                repeat_password: 'password123',
                name: 'First',
                lastname: 'Last',
                description: 'A new user',
                age: '25',
                profile_pic: 'profile1.png'
            }
            expect(last_response).to be_ok
            expect(last_response.body).to include('Username already exist')
        end

        it 'fails to register if passwords do not match' do
            post '/register', {
                username: 'anotheruser',
                password: 'password123',
                repeat_password: 'differentpassword',
                name: 'First',
                lastname: 'Last',
                description: 'A new user',
                age: '25',
                profile_pic: 'profile1.png'
            }
            expect(last_response).to be_ok
            expect(last_response.body).to include('Passwords are different')
        end
    end

    # Test para verificar que la ruta GET / va a la pagina home.
    describe 'GET /' do
        it 'renders the home page' do
            get '/'
            expect(last_response).to be_ok
            expect(last_response.body).to include('')
        end
    end

    describe 'GET /logout' do
        it 'renders the logout page' do
            get '/logout', {}, 'rack.session' => { username: 'testuser' }

            # Verificamos que la sesión esté vacía
            expect(last_request.env['rack.session']).to be_empty
            expect(last_response).to be_redirect
            follow_redirect!
            expect(last_request.path).to eq('/')
        end
    end

    describe 'GET /team' do
        it 'renders the team page' do
            get '/team'
            expect(last_response).to be_ok
            expect(last_response.body).to include('Team')
        end
    end

    describe 'GET /how-to-play' do
        it 'renders the howToPlay page' do
            get '/how-to-play'
            expect(last_response).to be_ok
            expect(last_response.body).to include('How to Play')
        end
    end

    describe 'POST /gamemodes/free' do
        let!(:user) { User.create(username: 'testuser', password: 'password123', cant_life: 2, cant_coins: 0) }
        let!(:question) { Question.create(name_question: 'Sample Question', level: 'easy', theme: 'free') }
        let!(:correct_option) { Option.create(name_option:'Correct Answer', correct: true, question: question) }
        let!(:incorrect_option) { Option.create(name_option:'Incorrect Answer', correct: false, question: question) }
      
        before do
          set_session(username: user.username)
        end
      
        context 'when you dont have more time left' do
          it 'reduces the users lives and redirects to /gamemodes if lives reaches 0' do
            user.update(cant_life: 1)
            post '/gamemodes/free', { timeout: 'true' }
      
            expect(user.reload.cant_life).to eq(0)
            expect(last_response).to be_redirect
            expect(last_response.location).to include('/gamemodes')
            expect(get_session[:message]).to eq("You have 0 lives. Please wait for lives to regenerate.")
            expect(get_session[:color]).to eq("red")
          end
      
          it 'reduces the users lives and continues if lives are still remaining' do
            post '/gamemodes/free', { timeout: 'true' }
      
            expect(user.reload.cant_life).to eq(1)
            expect(last_response).to be_redirect
            expect(last_response.location).to include('/gamemodes/free')
            expect(get_session[:message]).to eq("Time's up! Incorrect!")
            expect(get_session[:color]).to eq("red")
          end 
        end
      
        context 'when an incorrect option is selected' do
          it 'reduces the users lives and redirects if lives reached 0' do
            user.update(cant_life: 1)
            post '/gamemodes/free', { option_id: incorrect_option.id }
      
            expect(user.reload.cant_life).to eq(0)
            expect(last_response).to be_redirect
            expect(last_response.location).to include('/gamemodes')
            expect(get_session[:message]).to eq("You have 0 lives. Please wait for lives to regenerate.")
            expect(get_session[:color]).to eq("red")
          end
      
          it 'reduces the users lives and continues if lives are still remaining' do
            post '/gamemodes/free', { option_id: incorrect_option.id }
      
            expect(user.reload.cant_life).to eq(1)
            expect(last_response).to be_redirect
            expect(last_response.location).to include('/gamemodes/free')
            expect(get_session[:message]).to eq("Incorrect!")
            expect(get_session[:color]).to eq("red")
          end
        end
      
        context 'when a correct option is selected' do
          it 'increments the users coins and redirects to /gamemodes/free' do
            post '/gamemodes/free', { option_id: correct_option.id }
      
            expect(user.reload.cant_coins).to eq(10)
            expect(last_response).to be_redirect
            expect(last_response.location).to include('/gamemodes/free')
            expect(get_session[:message]).to eq("Correct! Well done.")
            expect(get_session[:color]).to eq("green")
          end
        end
      end
end
