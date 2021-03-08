require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }

  let (:question) { create(:question, user: user) }
  let (:answer) { create(:answer, question: question, user: user) }


  # describe 'GET #new' do
  #   it 'renders new view' do
  #     get :new, params: { question_id: question }

  #     expect(response).to render_template :new
  #   end
  # end

  describe 'POST #create' do
    before { login(user) }

    it 'associated with question' do
      post :create, params: valid_params
      expect(assigns(:question)).to eq answer.question
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: valid_params}.to change(Answer, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: valid_params
        expect(response).to redirect_to question
      end
    end

    context 'with invalids attributes' do
      it 'does not save the answer' do
        expect { post :create, params: invalid_params}.to_not change(Answer, :count)
      end

      it 're-renders question show view' do
        post :create, params: invalid_params
        expect(response).to render_template (:show)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let! (:answer) { create(:answer, question: question, user: user) }

    it 'assigns the requested answer to @answer' do
      delete :destroy, params: { id: answer }
      expect(assigns(:answer)).to eq answer
    end

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)      
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(question)
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
