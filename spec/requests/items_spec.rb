require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  let(:user) { create(:user) }
  let!(:todo) { create(:todo) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }
  let(:headers) { valid_headers }

  describe 'GET /todos/:todo_id/items' do
    context 'when todo exists' do
      before { get "/todos/#{todo_id}/items", params: {}, headers: headers }
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all items' do
        expect(json.size).to eq(20)
      end
    end

    context 'when todo does not exists' do
      let(:todo_id) { 0 }
      before { get "/todos/#{todo_id}/items", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe 'GET /todos/:todo_id/items/:id' do
    context 'when todo item exists' do
      before { get "/todos/#{todo_id}/items/#{id}", params: {}, headers: headers }

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "returns the item" do
        expect(json['id']).to eq(id)
      end
    end

    context 'when todo item does not exists' do
      let(:id) { 0 }
      before { get "/todos/#{todo_id}/items/#{id}", params: {}, headers: headers }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns not found message" do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'POST /todos/:todo_id/items' do
    let(:valid_attributes) { { name: 'Task 1', done: false}.to_json }

    context 'when request attributes are valid' do
      before { post "/todos/#{todo_id}/items", params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'creates an item' do
        expect(json['name']).to eq('Task 1')
      end
    end

    context 'when request attributes are invalid' do
      before { post "/todos/#{todo_id}/items", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PUT /todos/:todo_id/items/:id' do
    let(:valid_attributes) { { name: 'Mozart' }.to_json }
    
    context 'when item exists' do
      before { put "/todos/#{todo_id}/items/#{id}", params: valid_attributes, headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the item' do
        updated_item = Item.find(id)
        expect(updated_item.name).to eq('Mozart')
      end
    end

    context 'when item does not exists' do
      let(:id) { 0 }
      before { put "/todos/#{todo_id}/items/#{id}", params: valid_attributes, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'DELETE /items/:id' do
    before { delete "/todos/#{todo_id}/items/#{id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end