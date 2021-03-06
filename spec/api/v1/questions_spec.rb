require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }
    
    it_behaves_like 'API Authorizable'

    context 'authorized' do

      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, user: user, question: question) }

      before { get api_path, params: { access_token: access_token.token } , headers: headers }
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq questions.first.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id question_id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id/' do
    let(:question) { create(:question, user: create(:user)) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }
    
    it_behaves_like 'API Authorizable'

    it_behaves_like 'API Represented' do
      let(:object) { question }
      let(:resource) { :question }
    end
  end

  context 'POST PATCH DELETE' do
    let(:headers) { { "ACCEPT" => "application/json" } }

    describe 'POST /api/v1/questions' do
      let(:api_path) { "/api/v1/questions" }
      let(:method) { :post }
      
      it_behaves_like 'API Authorizable'

      it_behaves_like 'API Creatable' do
        let(:resource) { :question }
        let(:model) { Question }
        let(:title) { 'title' }
      end
    end

    describe 'DELETE /api/v1/questions/:id' do
      let(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :delete }
      
      it_behaves_like 'API Authorizable'

      it_behaves_like 'API Destroyable' do
        let(:resource) { question }
        let(:model) { Question }
      end
    end

    describe 'PATCH /api/v1/questions/:id' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :put }
      
      it_behaves_like 'API Authorizable'
       
      it_behaves_like 'API Updatable' do
        let(:resource) { :question }
      end
    end
  end
end
