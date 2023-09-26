require 'rails_helper'

RSpec.describe 'Users', type: :request do
  fixtures :all

  shared_context 'with authenticated user' do
    before do
      @user = users(:brian)
      @headers = { 'Authorization' => JsonWebToken.encode(user_id: @user.id) }
    end
  end

  describe 'GET /users' do
    context 'when user is logged in' do
      include_context 'with authenticated user'

      before { get '/users', headers: @headers }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all users' do
        response_body = JSON.parse(response.body).dig('data')

        expect(response_body).to be_an(Array)
        expect(response_body).to all(have_key('id'))

        attributes = response_body.first.dig('attributes')

        expect(attributes).to have_key('name')
        expect(attributes).to have_key('email')
      end
    end

    context 'when user is not logged in' do
      before { get '/users' }

      it 'returns 401 Unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /users/:user_id' do
    context 'when user is logged in' do
      include_context 'with authenticated user'

      before { get "/users/#{@user.id}", headers: @headers }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns user data' do
        response_body = JSON.parse(response.body).dig('data', 'attributes')

        expect(response_body).to have_key('name')
        expect(response_body).to have_key('email')
      end
    end

    context 'when user is not logged in' do
      before { get '/users' }

      it 'returns 401 Unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /users' do
    context 'when user data is valid' do
      before do
        post '/users', params: {
          name: "Brian O'Connor",
          email: 'fastandfurious@gmail.com',
          password: 'test123',
          password_confirmation: 'test123'
        }
      end

      it 'returns a 201 CREATED status code' do
        expect(response).to have_http_status(:created)
      end

      it 'returns data of user' do
        response_body = JSON.parse(response.body).dig('data', 'attributes')

        expect(response_body).to have_key('name')
        expect(response_body).to have_key('email')

        expect(response_body['name']).to eq("Brian O'Connor")
        expect(response_body['email']).to eq('fastandfurious@gmail.com')
      end
    end

    context 'when user data is not valid' do
      before do
        post '/users', params: {
          name: nil,
          email: nil,
          password: 'test123',
          password_confirmation: 'test123'
        }
      end

      it 'returns a 422 UNPROCESSABLE_ENTITY status code' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        response_body = JSON.parse(response.body)

        expect(response_body).to have_key('errors')
      end
    end
  end

  describe 'PUT /users/:user_id' do
    context 'when user is logged in' do
      include_context 'with authenticated user'

      before do
        put "/users/#{@user.id}", params: {
          name: "Brian O'Connor",
          email: 'fastandfurious@gmail.com'
        }, headers: @headers
      end

      it 'returns a 200 OK status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns data of user' do
        response_body = JSON.parse(response.body).dig('data', 'attributes')

        expect(response_body['name']).to eq("Brian O'Connor")
        expect(response_body['email']).to eq('fastandfurious@gmail.com')
      end
    end

    context 'when user is not logged in' do
      before do
        @user = users(:brian)

        put "/users/#{@user.id}", params: {
          name: "Brian O'Connor",
          email: 'fastandfurious@gmail.com'
        }
      end

      it 'returns a 401 Unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /users/:user_id' do
    context 'when user is logged in' do
      include_context 'with authenticated user'

      before { delete "/users/#{@user.id}", headers: @headers }

      it 'returns a 204 No_Content status code' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user is not logged in' do
      before do
        @user = users(:brian)

        delete "/users/#{@user.id}"
      end

      it 'returns a 401 Unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
