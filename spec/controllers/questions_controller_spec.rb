require 'rails_helper'
RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

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

    it 'assigns a new Answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a Link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link for question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
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

    context 'with invalids attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid), user: user}, format: :js }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'User is author' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: '123', body: '123' } }, format: :js
          question.reload

          expect(question.title).to eq '123'
          expect(question.body).to eq '123'
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalids attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }
        it 'does not change question attributes' do
          question.reload

          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end

        it 're-renders update view' do
          expect(response).to render_template :update        
        end
      end
    end

    context 'User is not author' do
      let (:author) { create(:user) }
      let! (:question) { create(:question, user: author) }

      before do 
        login(user)
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
      end
      
      it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq question
        end

      it 'does not change question attributes' do
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 're-renders update view' do
        expect(response).to render_template :update        
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'User is author' do
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

    context 'User is not author' do
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
