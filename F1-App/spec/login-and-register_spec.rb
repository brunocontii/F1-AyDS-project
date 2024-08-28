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

    # Test para verificar que la ruta GET / va a la pagina home.
    describe 'GET /' do
        it 'renders the home page' do
            get '/'
            expect(last_response).to be_ok
            expect(last_response.body).to include('')
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
            expect(last_response.status).to eq(200) # Verifica que esta todo ok.
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
end

# Tests para User Model
RSpec.describe User, type: :model do
    let(:user) { User.create(cant_life: 1, last_life_lost_at: 1.minutes.ago) }

    # Tests para regenerar vidas en el momento correcto
    describe '#regenerate_life_if_needed' do
        # Cuando las vidas pueden ser regeneradas
        context 'when lives can be regenerated' do
            # Cuando las vidas se regeneran correctamente, cantidad de vidas < 3
            it 'calculates lives_to_regenerate correctly' do
                allow(Time).to receive(:now).and_return(2.minutes.ago)
                user.regenerate_life_if_needed
                expect(user.cant_life).to eq(2)
            end

            # Cuando las vidas se regeneren que no exceda el maximo (3)
            it 'does not exceed the maximum of 3 lives' do
                user.update(cant_life: 2)
                allow(Time).to receive(:now).and_return(Time.now + 2.minutes) #2 minutos == 2 vidas nuevas en tiempo
                user.regenerate_life_if_needed
                expect(user.cant_life).to eq(3) #Si las vidas quedan en 3 y no 4 entonces es correcto
            end
        end

        # Cuando las vidas NO pueden ser regeneradas
        context 'when lives cannot be regenerated' do
            # Setea a nil la variable last_life_lost_at si no hay mas vidas para regenerar, asi no hay problemas
            # al perder vidas (por que sino regenera automaticamente)
            it 'resets last_life_lost_at to nil if no lives need regenerating' do
                allow(Time).to receive(:now).and_return(1.minutes.ago)
                user.update(cant_life: 3)
                user.regenerate_life_if_needed
                expect(user.last_life_lost_at).to be_nil
            end
        end
    end

    describe '#can_play?' do
        # Si la cantidad de vidas == 0 no puede jugar
        it 'returns false if cant_life is 0' do
            user.update(cant_life: 0)
            allow(Time).to receive(:now).and_return(10.seconds.ago) #Toma 10 segundos antes por que al inicializarse en 0 le suma 1 vida al instante
            expect(user.can_play?).to be_falsey
        end

        # Si la cantidad de vidas > 0 puede jugar
        it 'returns true if cant_life is greater than 0' do
            user.update(cant_life: 1)
            expect(user.can_play?).to be_truthy
        end
    end
end
