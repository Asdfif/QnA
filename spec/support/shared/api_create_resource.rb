shared_examples_for 'API Creatable' do

  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let(:user) { create(:user) }
    let(:body) { 'body' }
    let(:links_attributes) { { 0 => {name: "link", url: "http://127.0.0.1:3000/questions/new", _destroy:  false } } }

    before do
      post api_path, params: { 
                              access_token: access_token.token, 
                              resource => attributes(title , body, links_attributes)
                             }, 
                     headers: headers
    end
    
    let(:resource_response) { json[resource.to_s] }
    let(:resource_response_links) { resource_response['links'] }
    
    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'saves resource in DB' do
      expect(model.count).to eq 1    
    end

    it 'returns recource attributes' do
      expect(resource_response['title']).to eq 'title' if title
      expect(resource_response['body']).to eq body
    end

    it 'returns list of links' do
      expect(resource_response_links.size).to eq 1
      expect(resource_response_links.first['name']).to eq 'link'
      expect(resource_response_links.first['url']).to eq "http://127.0.0.1:3000/questions/new"
    end
  end
end

def attributes(title , body, links_attributes)
  if title
    { 
      title => 'title', 
      body: body, 
      links_attributes: links_attributes
    }
  else
    { 
      body: body, 
      links_attributes: links_attributes
    }
  end
end