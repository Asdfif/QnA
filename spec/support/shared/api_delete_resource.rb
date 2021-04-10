shared_examples_for 'API Destroyable' do

  context 'authorized' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    before do
      delete api_path, params: { 
                                access_token: access_token.token, 
                                id: resource.id 
                               }, 
                       headers: headers
    end
    
    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'changes resources count by -1' do
      expect(model.count).to eq 0      
    end
  end
end