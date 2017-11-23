require 'rails_helper'

RSpec.describe 'Answers API' do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 20, user_id: user.id, question_id: question.id) }
  let(:question_id) { question.id }
  let(:user_id) { user.id }
  let(:id) { answers.first.id }
  let(:headers) { valid_headers }

  describe 'GET /questions/:question_id/answers' do
    before { get "/questions/#{question_id}/answers", params: {}, headers: headers }

    context 'when question exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all question answers' do
        expect(json["data"].size).to eq(20)
      end
    end

    context 'when question does not exist' do
      let(:question_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Question/)
      end
    end
  end

  describe 'GET /questions/:question_id/answers/:id' do
    before { get "/questions/#{question_id}/answers/#{id}", params: {}, headers: headers }

    context 'when question answer exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the answer' do
        expect(json['data']['id'].to_i).to eq(id)
      end
    end

    context 'when question answer does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match (/Couldn't find Answer/)
      end
    end
  end

  describe 'POST /questions/:question_id/answers' do
    let(:valid_attributes) { { content: 'Lorem Ipsum', user_id: user_id }.to_json }

    context 'when request attributes are valid' do
      before { post "/questions/#{question_id}/answers", params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/questions/#{question_id}/answers", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: User must exist, Content can't be blank/)
      end
    end
  end

  describe 'PUT /questions/:question_id/answers/:id' do
    let(:valid_attributes) { { content: 'Ipsum Lorem' }.to_json }

    before { put "/questions/#{question_id}/answers/#{id}", params: valid_attributes, headers: headers }

    context 'when answer exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the answer' do
        updated_answer = Answer.find(id)
        expect(updated_answer.content).to match(/Ipsum Lorem/)
      end
    end

    context 'when the answer does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Answer/)
      end
    end
  end

  describe 'DELETE /questions/:question_id/answers/:id' do
    before { delete "/questions/#{question_id}/answers/#{id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
