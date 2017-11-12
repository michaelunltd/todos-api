require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end

  describe 'POST /signup' do
    context 'when valid request' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'creates a user' do
        expect(response).to have_http_status(201)
      end

      it 'returns a success message' do
        expect(response.body).to match(/Account created successfully/)
      end

      it 'returns an auth token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when invalid request' do
    end
  end
end