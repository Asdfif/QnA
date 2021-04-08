shared_examples_for 'API Updatable' do

  context 'authorized' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:body) { 'body' }
    let(:resource_response) { json[resource.to_s] }
    
    before do
      put api_path, params: { 
                              access_token: access_token.token, 
                              resource => { 
                                          body: body
                                        } 
                             }, 
                     headers: headers
    end
    
    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns resource new body' do
      expect(resource_response['body']).to eq body
    end
  end
end