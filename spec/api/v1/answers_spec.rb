require 'rails_helper'

describe 'Questions API', type: :request do
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

  describe 'GET /api/v1/questions/:id/' do
    let(:question) { create(:question, user: create(:user)) }
    let(:answer) { create(:answer, user: create(:user), question: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    let(:method) { :get }
    
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:comments) { create_list(:comment, 2, user: user, commentable: answer) }

      before do
        answer.links.build(name: attributes_for(:link)[:name], url: attributes_for(:link)[:url]).save
        # answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb', content_type: 'rb')
        answer.save
        get api_path, params: { access_token: access_token.token } , headers: headers
      end
      
      let(:answer_response) { json['answer'] }
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of comments' do
        expect(answer_response['comments'].size).to eq 2
      end

      it 'returns list of links' do
        expect(answer_response['links'].size).to eq 1
      end

      # it 'returns list of ttached files' do
      #   expect(answer_response['files'].size).to eq 1
      # end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:question) { create(:question, user: create(:user)) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :post }
    
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let(:body) { 'body' }
      let(:links_attributes) { { 0 => {name: "link", url: "http://127.0.0.1:3000/questions/new", _destroy:  false } } }

      before do
        post api_path, params: { 
                                access_token: access_token.token, 
                                answer: { 
                                          body: body, 
                                          links_attributes: links_attributes
                                        } 
                               }, 
                       headers: headers
      end
      
      let(:answer_response) { json['answer'] }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns answer body' do
        expect(answer_response['body']).to eq body
      end

      it 'returns list of links' do
        expect(answer_response['links'].size).to eq 1
        expect(answer_response['links'].first['name']).to eq 'link'
        expect(answer_response['links'].first['url']).to eq "http://127.0.0.1:3000/questions/new"
      end
    end
  end
end
