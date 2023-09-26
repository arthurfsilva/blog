require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  fixtures :all

  shared_context 'with authenticated user' do
    before do
      @user = users(:brian)
      @post = posts(:first)
      @comment = comments(:first)
      @headers = { 'Authorization' => JsonWebToken.encode(user_id: @user.id) }
    end
  end

  describe 'GET /posts/:id/comments' do
    context 'when user is logged in' do
      include_context 'with authenticated user'

      before { get "/posts/#{@post.id}/comments", headers: @headers }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all comments' do
        response_body = JSON.parse(response.body).dig('data')

        expect(response_body).to be_an(Array)
        expect(response_body).to all(have_key('id'))

        attributes = response_body.first.dig('attributes')

        expect(attributes).to have_key('name')
        expect(attributes).to have_key('body')
      end
    end
  end

  describe 'GET /posts/:id:/comments/:comment_id' do
    context 'when user is logged in' do
      include_context 'with authenticated user'

      before { get "/posts/#{@post.id}/comments/#{@comment.id}", headers: @headers }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns comment data' do
        response_body = JSON.parse(response.body).dig('data', 'attributes')

        expect(response_body).to have_key('name')
        expect(response_body).to have_key('body')
      end
    end
  end

  describe 'POST /posts/:id/comments' do
    context 'when comment data is valid' do
      include_context 'with authenticated user'

      before do
        post "/posts/#{@post.id}/comments", params: {
          comment: {
            name: 'This is my first Comment',
            body: 'This is an example of body'
          }
        }, headers: @headers
      end

      it 'returns a 201 CREATED status code' do
        expect(response).to have_http_status(:created)
      end

      it 'returns data of comment' do
        response_body = JSON.parse(response.body).dig('data', 'attributes')

        expect(response_body).to have_key('name')
        expect(response_body).to have_key('body')

        expect(response_body['name']).to eq('This is my first Comment')
        expect(response_body['body']).to eq('This is an example of body')
      end
    end

    context 'when comment data is not valid' do
      include_context 'with authenticated user'

      before do
        post "/posts/#{@post.id}/comments", params: {
          comment: {
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

  describe 'PUT /posts/:id/comments/:comment_id' do
    context 'when user is logged in' do
      include_context 'with authenticated user'

      before do
        put "/posts/#{@post.id}/comments/#{@comment.id}", params: {
          comment: {
            name: "This is my first Comment (Updated)",
            body: "This is an example of content (Updated)"
          }
        }, headers: @headers
      end

      it 'returns a 200 OK status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns data of comment' do
        response_body = JSON.parse(response.body).dig('data', 'attributes')

        expect(response_body['name']).to eq("This is my first Comment (Updated)")
        expect(response_body['body']).to eq('This is an example of content (Updated)')
      end
    end
  end

  describe 'DELETE /comments/:comment_id' do
    context 'when user is logged in' do
      include_context 'with authenticated user'

      before { delete "/posts/#{@post.id}/comments/#{@comment.id}", headers: @headers }

      it 'returns a 204 No_Content status code' do
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
