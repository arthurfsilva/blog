require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  fixtures :all

  describe 'GET /auth/login' do
    context 'when user login is valid' do
      before do
        @user = users(:brian)

        post '/auth/login', params: {
          email: 'smith.brian@gmail.com',
          password: 'teste123'
        }
      end

      it 'returns token' do
        response_body = JSON.parse(response.body)
        expect(response_body['token']).not_to be_nil
      end
    end

    context 'when user login is invalid' do
      before do
        @user = users(:brian)

        post '/auth/login', params: {
          email: 'smith.brian@gmail.com',
          password: 'wrongpassword'
        }
      end

      it 'returns unauthorized' do
        response_body = JSON.parse(response.body)

        expect(response).to have_http_status(:unauthorized)
        expect(response_body['errors']).to eq('unauthorized')
      end
    end
  end
end
