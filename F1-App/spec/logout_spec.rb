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

     # Test para verificar que la ruta GET /logout va a la pagina /.
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

end
