require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  fixtures :all

  shared_context 'with authenticated user' do
    before do
      @user = users(:brian)
      @post = posts(:first)
      @headers = { 'Authorization' => JsonWebToken.encode(user_id: @user.id) }
    end
  end

  describe 'GET /posts' do
    context 'when user is logged in' do

      before { get '/posts', headers: @headers }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all posts' do
        response_body = JSON.parse(response.body).dig('data')

        expect(response_body).to be_an(Array)
        expect(response_body).to all(have_key('id'))

        attributes = response_body.first.dig('attributes')

        expect(attributes).to have_key('title')
        expect(attributes).to have_key('content')
      end
    end
  end

  describe 'GET /posts/:post_id' do
    context 'when user is logged in' do
      include_context 'with authenticated user'

      before { get "/posts/#{@post.id}", headers: @headers }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns post data' do
        response_body = JSON.parse(response.body).dig('data', 'attributes')

        expect(response_body).to have_key('title')
        expect(response_body).to have_key('content')
      end
    end
  end

  describe 'POST /posts' do
    context 'when post data is valid' do
      include_context 'with authenticated user'

      before do
        post '/posts', params: {
          post: {
            title: 'This is my first Post',
            content: 'This is an example of content'
          }
        }, headers: @headers
      end

      it 'returns a 201 CREATED status code' do
        expect(response).to have_http_status(:created)
      end

      it 'returns data of post' do
        response_body = JSON.parse(response.body).dig('data', 'attributes')

        expect(response_body).to have_key('title')
        expect(response_body).to have_key('content')

        expect(response_body['title']).to eq('This is my first Post')
        expect(response_body['content']).to eq('This is an example of content')
      end
    end

    context 'when post data is not valid' do
      include_context 'with authenticated user'

      before do
        post '/posts', params: {
          post: {
            title: nil,
            content: "This is an example of content"
          }
        }, headers: @headers
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

  describe 'PUT /posts/:post_id' do
    context 'when user is logged in' do
      include_context 'with authenticated user'

      before do
        put "/posts/#{@post.id}", params: {
          post: {
            title: "This is my first Post (Updated)",
            content: "This is an example of content (Updated)"
          }
        }, headers: @headers
      end

      it 'returns a 200 OK status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns data of post' do
        response_body = JSON.parse(response.body).dig('data', 'attributes')

        expect(response_body['title']).to eq("This is my first Post (Updated)")
        expect(response_body['content']).to eq('This is an example of content (Updated)')
      end
    end

    context 'when user is not logged in' do
      before do
        @post = posts(:first)

        put "/posts/#{@post.id}", params: {
          post: {
            title: "This is my first Post (Updated)",
            content: "This is an example of content (Updated)"
          }
        }
      end

      it 'returns a 401 Unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /posts/:post_id' do
    context 'when user is logged in' do
      include_context 'with authenticated user'

      before { delete "/posts/#{@post.id}", headers: @headers }

      it 'returns a 204 No_Content status code' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user is not logged in' do
      before do
        @post = posts(:first)

        delete "/posts/#{@post.id}"
      end

      it 'returns a 401 Unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
