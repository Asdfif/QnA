require 'rails_helper'
RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let (:question) { create(:question, user: user) }

  describe 'GET #index' do
    let (:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question), user: user}}.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with unvalids attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid), user: user}}.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: '123', body: '123' } }
        question.reload

        expect(question.title).to eq '123'
        expect(question.body).to eq '123'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalids attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }
      it 'does not change question' do
        question.reload

        expect(question.title).to eq attributes_for(:question)[:title]
        expect(question.body).to eq attributes_for(:question)[:body]
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit        
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'User is author' do
      let (:author) { create(:user) }
      before { login(author) }

      let! (:question) { create(:question, user: author) }

      it 'assigns the requested question to @question' do
        delete :destroy, params: { id: question }
        expect(assigns(:question)).to eq question
      end

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)      
      end

      it 'redirects to show' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    describe 'User is not author' do
      let (:author) { create(:user) }
      before { login(user) }

      let! (:question) { create(:question, user: author) }
      
      it 'assigns the requested question to @question' do
        delete :destroy, params: { id: question }
        expect(assigns(:question)).to eq question
      end

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)     
      end

      it 'redirects to show' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
