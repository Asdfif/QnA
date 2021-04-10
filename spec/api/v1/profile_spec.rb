require 'rails_helper'

describe 'Profile API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  
  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do

      before { get api_path, params: { access_token: access_token.token } , headers: headers }
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/others' do
    let(:api_path) { '/api/v1/profiles' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:others_profiles) { create_list(:user, 3) }
      let(:profiles_response) { json['profiles'] }
     
      before { get api_path, params: { access_token: access_token.token } , headers: headers }
            
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of others profile' do
        expect(profiles_response.size).to eq 3
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(profiles_response.first[attr]).to eq others_profiles.first.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(profiles_response.first).to_not have_key(attr)
        end
      end
    end
  end
end
