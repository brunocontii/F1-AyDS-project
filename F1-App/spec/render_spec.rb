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

  # Test para verificar que la ruta GET / va a la pagina home.
  describe 'GET /' do
    it 'renders the home page' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('')
    end
  end

  # Test para verificar que la ruta GET /team va a la pagina efectivamente a Team.
  describe 'GET /team' do
    it 'renders the team page' do
      get '/team'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Team')
    end
  end

  # Test para verificar que la ruta GET /team va a la pagina efectivamente a Team.
  describe 'GET /how-to-play' do
    it 'renders the howToPlay page' do
      get '/how-to-play'
      expect(last_response).to be_ok
      expect(last_response.body).to include('How to Play')
    end
  end
end
