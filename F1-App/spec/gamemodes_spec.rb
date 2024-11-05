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

  describe 'GET /gamemodes (logged in user)' do
    context 'when user is logged in' do
      let(:user) { User.create(username: 'testuser', password: 'testpassword', cant_life: 3, cant_coins: 0) }

      before { env 'rack.session', { username: user.username } }

      it 'returns JSON with lives when requested via AJAX' do
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
  end

  describe 'GET /gamemodes (not logged in user)' do
    context 'when user is not logged in' do
      it 'redirects to home page' do
        get '/gamemodes'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/')
      end
    end
  end
end
