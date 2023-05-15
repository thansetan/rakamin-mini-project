require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  let(:user) { create(:user) }
  let!(:todos) { create_list(:todo, 10, created_by: user.id) } # if todos is empty, create 10 fake todo objects
  let(:todo_id) { todos.first.id } # create todo_id var, and assign first todo id

  let(:headers) { valid_headers }
  describe 'GET /todos' do
    before { get '/todos', params: {}, headers: }

    it 'returns todos' do
      expect(json).not_to be_empty # response body musn't be empty
      expect(json.size).to eq(10) # must have 10 items
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200) # return 200 OK status code
    end
  end

  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}", params: {}, headers: } # get todo with valid todo id

    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty # response body musn't be empty
        expect(json['id']).to eq(todo_id) # the todo id in response must match requested todo id
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record doesn\'t exist' do
      let(:todo_id) { 100 } # get todo with todo id = 100 (invalid)

      it 'returns status code 404' do
        expect(response).to have_http_status(404) # return 404 not found status code
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/) # response body must be "Couldn't find Todo"
      end
    end
  end

  describe 'POST /todos' do
    let(:valid_attributes) { { title: 'WOW KEREN', created_by: user.id.to_s }.to_json } # Example of valid todo input

    context 'when the request is valid' do
      before { post '/todos', params: valid_attributes, headers: }

      it 'creates a todo' do
        expect(json['title']).to eq('WOW KEREN') # Must return a JSON with the title matching user input title
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201) # return 201 created status code
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { title: nil }.to_json }
      # Example of invalid todo input (created by is empty)
      before do
        post '/todos', params: invalid_attributes, headers:
      end
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['message'])
          .to match(/Validation failed: Title can't be blank/) # response body must be "Validation failed: Created by can't be blank"
      end
    end
  end

  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title: 'Shopping' }.to_json } # edit todo title to "Shopping"

    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes, headers: }

      it 'updates the record' do
        expect(response.body).to be_empty # response body should be empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204) # return 204 No Content status code
      end
    end
  end

  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}", params: {}, headers: }

    it 'returns status code 204' do
      expect(response).to have_http_status(204) # return 204 No Content status code
    end
  end
end
