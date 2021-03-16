require 'rails_helper'
RSpec.describe AnswersController, type: :controller do
  let (:user) { create(:user) }
  let (:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    it 'associated with question' do
      post :create, params: valid_params, format: :js
      expect(assigns(:answer).question).to eq question
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
        delete :destroy, params: { id: answer }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)      
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User is not author' do
      let (:author) { create(:user) }
      before { login(user) }
      let! (:answer) { create(:answer, question: question, user: author) }

      it 'assigns the requested answer to @answer' do
        delete :destroy, params: { id: answer }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it ' do not deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)     
      end

      # !!!!!!!!!!
      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    context 'User is author' do
      before { login(user) }

      let!(:answer) { create(:answer, question: question, user: user) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do 
        it 'does not change answer attributes' do
          expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'User is not author' do
      let (:author) { create(:user) }
      let!(:answer) { create(:answer, question: question, user: author) }

      before do 
        login(user)
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
      end
      
      it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

      it 'does not change answer attributes' do
        answer.reload

        expect(answer.body).to eq answer.body
      end

      it 're-renders update view' do
        expect(response).to render_template :update        
      end
    end
  end


  describe 'PATCH #make_it_best', js: true do
    context 'User is not author' do
      let(:not_author) { create(:user) }
      let!(:answer) { create(:answer, user: user, question: question) }
      
      before do 
        login(not_author)
        patch :make_it_best, params: { id: answer }, format: :js
      end

      it 'does not changes attribute "best" for true' do
        answer.reload

        expect(answer.best).to_not eq true
      end

      it "does not changes question's best answer for self" do
        question.reload
        expect(question.best_answer).to_not eq answer
      end

    end

    context 'User is author' do
      let!(:answer) { create(:answer, user: user, question: question) }
      
      before do 
        login(user)
        patch :make_it_best, params: { id: answer }, format: :js
      end

      it 'changes attribute "best" for true' do
        answer.reload

        expect(answer.best).to eq true
      end

      it "changes question's best answer for self" do
        question.reload
        expect(question.best_answer).to eq answer
      end
    end
  end

  describe 'PATCH #delete_file' do
    let!(:answer) { create(:answer, user: user, question: question) }

    before do
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb', content_type: 'rb')
    end

    it "Author deletes answer's file" do
      login(user)
      patch :delete_file, params: { id: answer, file_id: answer.files.first.id }, format: :js

      expect(answer.files.all).to be_empty
    end

    it "Not an author deletes question's file" do
      patch :delete_file, params: { id: answer, file_id: answer.files.first.id }, format: :js

      expect(answer.files.all).to_not be_empty
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
