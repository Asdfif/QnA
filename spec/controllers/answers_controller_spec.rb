require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let (:question) { create(:question) }
  let (:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    it 'renders new view' do
      get :new, params: { question_id: question }

      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    it 'associated with question' do
      post :create, params: valid_params
      expect(assigns(:question)).to eq answer.question
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: valid_params}.to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: valid_params
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with unvalids attributes' do
      it 'does not save the answer' do
        expect { post :create, params: invalid_params}.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: invalid_params
        expect(response).to render_template :new
      end
    end

  private
    def valid_params
      { answer: attributes_for(:answer), question_id: question.id }
    end

    def invalid_params
      { answer: attributes_for(:answer, :invalid), question_id: question.id }
    end
  end
end
