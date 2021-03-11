require 'rails_helper'
RSpec.describe AnswersController, type: :controller do
  let (:user) { create(:user) }
  let (:question) { create(:question, user: user) }
  let (:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    it 'associated with question' do
      post :create, params: valid_params, format: :js
      expect(assigns(:question)).to eq answer.question
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: valid_params, format: :js}.to change(Answer, :count).by(1)
      end

      it 'renders answers/create view' do
        post :create, params: valid_params, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalids attributes' do
      it 'does not save the answer' do
        expect { post :create, params: invalid_params, format: :js}.to_not change(Answer, :count)
      end

      it 're-renders question show view' do
        post :create, params: invalid_params, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'User is author' do
      let (:author) { create(:user) }
      before { login(author) }
      let! (:answer) { create(:answer, question: question, user: author) }

      it 'assigns the requested answer to @answer' do
        delete :destroy, params: { id: answer }
        expect(assigns(:answer)).to eq answer
      end

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)      
      end

      it 'redirects to question#show' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'User is not author' do
      let (:author) { create(:user) }
      before { login(user) }
      let! (:answer) { create(:answer, question: question, user: author) }

      it 'assigns the requested answer to @answer' do
        delete :destroy, params: { id: answer }
        expect(assigns(:answer)).to eq answer
      end

      it ' do not deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)     
      end

      it 'redirects to question#show' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  private
 
  def valid_params
    { answer: attributes_for(:answer), question_id: question.id, user: user}
  end

  def invalid_params
    { answer: attributes_for(:answer, :invalid), question_id: question.id, user: user}
  end 
end
