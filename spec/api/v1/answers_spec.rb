require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } } 

  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question, user: create(:user)) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :get }
    
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:answers) { create_list(:answer, 2, user: user, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token } , headers: headers }
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id/' do
    let(:question) { create(:question, user: create(:user)) }
    let(:answer) { create(:answer, user: create(:user), question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :get }
    
    it_behaves_like 'API Authorizable'

    it_behaves_like 'API Represented' do
      let(:object) { answer }
      let(:resource) { :answer }
    end
  end

  context 'POST PATCH DELETE' do
    let(:headers) { { "ACCEPT" => "application/json" } }

    describe 'POST /api/v1/questions/:question_id/answers' do
      let(:question) { create(:question, user: create(:user)) }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :post }
      
      it_behaves_like 'API Authorizable'

      it_behaves_like 'API Creatable' do
        let(:resource) { :answer }
        let(:model) { Answer }
        let(:title) { nil }
      end
    end

    describe 'DELETE /api/v1/questions/:i' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, user: user, question: question) }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :delete }
      
      it_behaves_like 'API Authorizable'

      it_behaves_like 'API Destroyable' do
        let(:resource) { answer }
        let(:model) { Answer }
      end
    end

    describe 'PATCH /api/v1/answers/:id' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let(:answer) { create(:answer, user: user, question: question) }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :put }
      
      it_behaves_like 'API Authorizable'

      it_behaves_like 'API Updatable' do
        let(:resource) { :answer }
      end
    end
  end
end
