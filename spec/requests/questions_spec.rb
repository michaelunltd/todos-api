require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
  let!(:questions) { create_list(:question, 10) }
  let(:question_id) { questions.first.id }

  describe 'GET /questions' do
    before { get '/questions', params: {} }
    it 'returns questions' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /questions/:id' do
    before { get "/questions/#{question_id}", params: {} }
    context 'when the record exist' do
      it 'returns the question' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(question_id)
      end

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:question_id){ 0 }
      it 'return status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /questions' do
    let(:valid_attributes) { { title: 'Hi, is this a question?', body: 'question is to be answered properly'} }
    context 'when the request is valid' do
      before { post '/questions', params: valid_attributes }
      it 'creates a question' do
        expect(json['title']).to eq('Hi, is this a question?')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/questions', params: {} }
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns a validation error message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  describe 'PUT /questions/:id' do
    let(:valid_attributes) { {title: 'New title'} }
    context 'when the record exists' do
      before { put "/questions/#{question_id}", params: valid_attributes }
    end

    context 'when the record does not exists' do
      let(:question_id) { 0 }
      before { put "/questions/#{question_id}", params: valid_attributes }

      it 'returns the status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Question/)
      end
    end
  end

  describe 'DELETE /questions/:id' do
    before { delete "/questions/#{question_id}", params: {} }
    it 'returns status code' do
      expect(response).to have_http_status(204)
    end
  end
end