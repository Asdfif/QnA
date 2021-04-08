shared_examples_for 'Destroyed' do
  context 'User is author' do
    before { login(author) }

    it 'assigns the requested resource to @resource' do
      test_request
      expect(assigns(klass)).to eq object
    end

    it 'deletes the resource' do
      expect { test_request }.to change(model, :count).by(-1)      
    end
  end

  context 'User is not author' do
    before { login(user) }

    it 'assigns the requested resource to @resource' do
      test_request
      expect(assigns(klass)).to eq object
    end

    it ' do not deletes the resource' do
      expect { test_request }.to_not change(model, :count)     
    end
  end
end

def test_request
  case klass
  when :question
    delete :destroy, params: { id: object }
  when :answer
    delete :destroy, params: { id: object }, format: :js
  end
end

def assignings
  it 'assigns the requested resource to @resource' do
    request
    expect(assigns(klass)).to eq object
  end
end