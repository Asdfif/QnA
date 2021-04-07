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

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:comments) { create_list(:comment, 2, user: user, commentable: question) }

      before do
        question.links.build(name: attributes_for(:link)[:name], url: attributes_for(:link)[:url]).save
        # question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb', content_type: 'rb')
        question.save
        get api_path, params: { access_token: access_token.token } , headers: headers
      end
      
      let(:question_response) { json['question'] }
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of comments' do
        expect(question_response['comments'].size).to eq 2
      end

      it 'returns list of links' do
        expect(question_response['links'].size).to eq 1
      end

      # it 'returns list of ttached files' do
      #   expect(question_response['files'].size).to eq 1
      # end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:api_path) { "/api/v1/questions" }
    let(:method) { :post }
    
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let(:title) { 'title' }
      let(:body) { 'body' }
      let(:links_attributes) { { 0 => {name: "link", url: "http://127.0.0.1:3000/questions/new", _destroy:  false } } }

      before do
        post api_path, params: { 
                                access_token: access_token.token, 
                                question: { 
                                            title: title, 
                                            body: body, 
                                            links_attributes: links_attributes
                                          } 
                               }, 
                       headers: headers
      end
      
      let(:question_response) { json['question'] }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns question title and body' do
        expect(question_response['title']).to eq title
        expect(question_response['body']).to eq body
      end

      it 'returns list of links' do
        expect(question_response['links'].size).to eq 1
        expect(question_response['links'].first['name']).to eq 'link'
        expect(question_response['links'].first['url']).to eq "http://127.0.0.1:3000/questions/new"
      end
    end
  end
end
