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

    describe 'GET /profile' do
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
    end

    describe 'POST /profile/picture' do
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

            let(:profile_picture_file) { Dir.glob("public/profile_pictures/*.png").sample }

            before do
                env 'rack.session', { username: user.username }
                profile
            end

            it 'updates the profile picture' do
                post '/profile/picture', profile_picture: "/public/profile_pictures/#{File.basename(profile_picture_file)}"
                updated_profile = Profile.find_by(user_id: user.id)
                expect(updated_profile.profile_picture).to eq("/public/profile_pictures/#{File.basename(profile_picture_file)}")
                expect(last_response).to be_redirect
                follow_redirect!
                expect(last_request.path).to eq('/profile')
            end
        end

        context 'when user is not logged in' do
            it 'redirects to home page' do
                post '/profile/picture'
                expect(last_response).to be_redirect
                follow_redirect!
                expect(last_request.path).to eq('/')
            end
        end
    end

    describe 'GET /gamemodes/progressive' do
        context 'when user is loggen in' do
            let(:user) do
                User.create(
                    username: 'testuser',
                    password: 'testpassword',
                    cant_life: 2,
                    cant_coins: 130
                )
            end
    
            before do
                env 'rack.session', { username: user.username }
            end
    
            it 'returns JSON with lives when requested via AJAX' do
                env 'rack.session', { username: user.username }
                get '/gamemodes/progressive', {}, 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest'
                expected_response = { lives: user.cant_life,}.to_json
                
                expect(last_response).to be_ok
                expect(last_response.content_type).to eq('application/json')
                expect(last_response.body).to eq(expected_response)
            end
    
            it 'renders gamemodes template when not requested via AJAX' do
                get '/gamemodes/progressive'
                expect(last_response.body).to include(user.cant_life.to_s)
                expect(last_response.body).to include(user.cant_coins.to_s)
                expect(last_response.body).to include('Progressive')
            end
        end
    
        context 'when user is not logged in' do
            it 'redirects to home page' do
                get '/gamemodes/progressive'
                expect(last_response).to be_redirect
                follow_redirect!
                expect(last_request.path).to eq('/')
            end
        end
    end
    
    describe 'GET /gamemodes/progressive/:mode' do
        ['pilot', 'team', 'career', 'circuit'].each do |mode|
            context "when mode is #{mode}" do
                let(:user) do
                    User.create(
                        username: 'testuser',
                        password: 'testpassword',
                        cant_life: 3,
                        cant_coins: 220
                    )
                end
          
                before do
                    env 'rack.session', { username: user.username }
                    # Preparando pregunta y respuestas para testear
                    @question = Question.create(name_question: 'Sample Question', level: 'easy', theme: mode)
                    @correct_option = Option.create(name_option: 'Correct Option', question_id: @question.id, correct: true)
                    @incorrect_option1 = Option.create(name_option: 'Incorrect Option 1', question_id: @question.id, correct: false)
                    @incorrect_option2 = Option.create(name_option: 'Incorrect Option 2', question_id: @question.id, correct: false)
                    @incorrect_option3 = Option.create(name_option: 'Incorrect Option 3', question_id: @question.id, correct: false)
                end
    
                # Si la pregunta se muestra, que se muestre tanto la pregunta 
                # como la opcion correcta y las 3 incorrectas.
                it 'displays a question and its options if available' do
                    get "/gamemodes/progressive/#{mode}"
                    expect(last_response).to be_ok
                    expect(last_response.body).to include(@question.name_question)
                    expect(last_response.body).to include(@correct_option.name_option)
                    expect(last_response.body).to include(@incorrect_option1.name_option)
                    expect(last_response.body).to include(@incorrect_option2.name_option)
                    expect(last_response.body).to include(@incorrect_option3.name_option)
                end
    
                # Si no hay preguntas ya disponibles porque fueron contestadas todas correctamente
                # se borrarian todas y me redirecciono a gamemodes. 
                it 'redirects to /gamemodes if no questions available' do
                    Option.delete_all # Se elimina antes de question ya que sino no se podria, son dependientes
                    Question.delete_all # se hace por las dudas que este cargada la bdd con algo externo a este test
                    get "/gamemodes/progressive/#{mode}"
                    expect(last_response).to be_redirect
                    follow_redirect!
                    expect(last_request.path).to eq('/gamemodes')
                end
                    
                # Si no hay vidas, tendrian que estar en 0 y me redirecciono a /gamemodes
                it 'redirects to /gamemodes if no lives available' do
                    user.update(cant_life: 0)
                    get "/gamemodes/progressive/#{mode}"
                    expect(last_response).to be_redirect
                    follow_redirect!
                    expect(last_request.path).to eq('/gamemodes')
                end
    
            end
        end
    
    end

    describe 'GET /gamemodes' do
        context 'when user is loggen in' do
            let(:user) do
                User.create(
                    username: 'testuser',
                    password: 'testpassword',
                    cant_life: 3,
                    cant_coins: 0
                )
            end

            before do
                env 'rack.session', { username: user.username }
            end

            it 'returns JSON with lives when requested via AJAX' do
                env 'rack.session', { username: user.username }
                get '/gamemodes', {}, 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest'
                expect(last_response.content_type).to eq('application/json')
                expect(last_response.body).to eq({ lives: user.cant_life }.to_json)
            end

            it 'renders gamemodes template when not requested via AJAX' do
                get '/gamemodes'
                expect(last_response).to be_ok
                expect(last_response.body).to include('Gamemodes')
            end
        end

        context 'when user is not logged in' do
            it 'redirects to home page' do
                get '/gamemodes'
                expect(last_response).to be_redirect
                follow_redirect!
                expect(last_request.path).to eq('/')
            end
        end
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
        # Definiciones temporales para las pruebas
        let!(:user) { User.create(username: 'testuser', password: 'password123', cant_life: 3, cant_coins: 0) }
        let!(:question) { Question.create(name_question: 'Sample Question', level: 'easy', theme: 'free') }
        let!(:correct_option) { Option.create(name_option:'Correct Answer', correct: true, question: question) }
        let!(:incorrect_option) { Option.create(name_option:'Incorrect Answer', correct: false, question: question) }

        # Verificación de sesión
        before do
            env 'rack.session', { username: user.username }
        end
      
        #Cuando no tenemos más tiempo
        context 'when you dont have more time left' do
          it 'reduces the users lives and redirects to /gamemodes if lives reaches 0' do
            user.update(cant_life: 1)
            post '/gamemodes/free', { timeout: 'true' }
      
            expect(user.reload.cant_life).to eq(0)
            expect(last_response).to be_redirect
            expect(last_response.location).to include('/gamemodes')
            expect(last_request.env['rack.session'][:message]).to eq("You have 0 lives. Please wait for lives to regenerate.")
            expect(last_request.env['rack.session'][:color]).to eq("red")
          end
      
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
          it 'reduces the users lives and redirects if lives reached 0' do
            user.update(cant_life: 1)
            post '/gamemodes/free', { option_id: incorrect_option.id }
      
            expect(user.reload.cant_life).to eq(0)
            expect(last_response).to be_redirect
            expect(last_response.location).to include('/gamemodes')
            expect(last_request.env['rack.session'][:message]).to eq("You have 0 lives. Please wait for lives to regenerate.")
            expect(last_request.env['rack.session'][:color]).to eq("red")
          end
      
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
