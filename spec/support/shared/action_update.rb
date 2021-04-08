shared_examples_for 'Updatable' do
  context 'User is author' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested model to @model' do
        patch :update, params: { id: object, model => attributes_for(model) }, format: :js
        expect(assigns(model)).to eq object
      end

      it 'changes model attributes' do
        patch :update, params: { id: object, model => { body: '123' } }, format: :js
        object.reload

        expect(object.body).to eq '123'
      end

      it 'renders update view' do
        patch :update, params: { id: object, model => attributes_for(model) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalids attributes' do
      before { patch :update, params: { id: object, model => attributes_for(model, :invalid) }, format: :js }
      it 'does not change model attributes' do
        object.reload

        expect(object.body).to eq object.body
      end

      it 're-renders update view' do
        expect(response).to render_template :update        
      end
    end
  end

  context 'User is not author' do
    let (:author) { create(:user) }
    let! (:object) do 
      case model
      when :answer
        create(model, user: author, question: question)
      when :question
        create(model, user: author)
      end
    end
    before do 
      login(user)
      patch :update, params: { id: object, model => attributes_for(model) }, format: :js
    end
    
    it 'assigns the requested model to @model' do
        expect(assigns(model)).to eq object
      end

    it 'does not change model attributes' do
      object.reload

      expect(object.body).to eq object.body
    end

    it 'have http status 403' do
      expect(response).to have_http_status(:forbidden)
    end
  end
end
