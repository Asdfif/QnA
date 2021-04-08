require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like "Voted"

  let (:user) { create(:user) }
  let (:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    it 'associated with question' do
      post :create, params: valid_params, format: :js
      expect(assigns(:answer).question).to eq question
    end

    it_behaves_like 'Savable' do
      let(:model) { Answer }
    end
  end

  describe 'DELETE #destroy' do
      let (:author) { create(:user) }
      let! (:answer) { create(:answer, question: question, user: author) }

    context 'User is author' do
      before { login(author) }

      # it 'assigns the requested answer to @answer' do
      #   delete :destroy, params: { id: answer }, format: :js
      #   expect(assigns(:answer)).to eq answer
      # end

      # it 'deletes the answer' do
      #   expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)      
      # end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User is not author' do
      before { login(user) }

      # it 'assigns the requested answer to @answer' do
      #   delete :destroy, params: { id: answer }, format: :js
      #   expect(assigns(:answer)).to eq answer
      # end

      # it ' do not deletes the answer' do
      #   expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)     
      # end

      it 'have http status 403' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end

    it_behaves_like 'Destroyed' do
      let(:klass) { :answer }
      let(:object) { answer }
      let(:model) { Answer }
    end
  end

  describe 'PATCH #update' do
    it_behaves_like 'Updatable' do
      let(:answer) { create(:answer, user: user, question: question) }
      let(:model) { :answer }
      let(:object) { answer }
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
      let!(:reward) { create(:reward, question: question) }
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

      it "changes question's reward's user to answer's author" do
        question.reload

        expect(question.reward.user).to eq user
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
