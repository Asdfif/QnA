shared_examples_for 'Savable' do
  context 'with valid attributes' do
    it 'saves a new resource in the database' do
      expect { post :create, params: valid_params, format: :js }.to change(model, :count).by(1)
    end
  end

  context 'with invalids attributes' do
    it 'does not save the resource' do
      expect { post :create, params: invalid_params, format: :js }.to_not change(model, :count)
    end
  end
end
