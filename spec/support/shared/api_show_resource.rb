shared_examples_for 'API Represented' do
  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let(:user) { create(:user) }
    let!(:comments) { create_list(:comment, 2, user: user, commentable: object) }

    before do
      object.links.build(name: attributes_for(:link)[:name], url: attributes_for(:link)[:url]).save
      # object.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb', content_type: 'rb')
      object.save
      get api_path, params: { access_token: access_token.token } , headers: headers
    end
    
    let(:resource_response) { json[resource.to_s] }
    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns list of comments' do
      expect(resource_response['comments'].size).to eq 2
    end

    it 'returns list of links' do
      expect(resource_response['links'].size).to eq 1
    end

    # it 'returns list of ttached files' do
    #   expect(resource_response['files'].size).to eq 1
    # end
  end
end