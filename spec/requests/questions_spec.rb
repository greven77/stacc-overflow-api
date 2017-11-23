require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
  let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 10, author: user, tag_list: Faker::Lorem.words(3)) }
  let(:question_id) { questions.first.id }

  let(:headers) { valid_headers }

  describe 'GET /questions' do
    before { get '/questions' , params: {}, headers: headers }

    it 'returns questions' do
      expect(json["data"]).not_to be_empty
      expect(json["data"].size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /questions/:id' do
    before { get "/questions/#{question_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the question' do
        expect(json).not_to be_empty
        expect(json['data']['id'].to_i).to eq(question_id)
      end

      it 'returns status code to 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:question_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Question/)
      end
    end
  end

  describe 'POST /questions' do
    let(:valid_attributes) do
      {
        title: 'How do I shot web?', content: 'I dunno LUL lorem', author_id: user.id.to_s,
        tag_list: ["javascript", "react", "redux"].to_s
      }.to_json
    end

    context 'when the request is valid' do
      before { post '/questions', params: valid_attributes, headers: headers }

      it 'creates a question' do
        expect(json['data']['attributes']['title']).to eq('How do I shot web?')
        expect(json['data']['attributes']['content']).to eq('I dunno LUL lorem')
        expect(json['data']['relationships']['tags']['data'].count).to eq(3)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:valid_attributes) { { title: nil }.to_json }
      before { post '/questions', params: valid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Author must exist, Title can't be blank, Content can't be blank/)
      end
    end
  end

  describe 'PUT /questions/:id' do
    let(:valid_attributes) {{ title: 'not quite sure',
                              tag_list: ["one", "two"]}.to_json }

    context 'when the record exists' do
      before { put "/questions/#{question_id}", params: valid_attributes, headers: headers  }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /questions/:id' do
    before { delete "/questions/#{question_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
