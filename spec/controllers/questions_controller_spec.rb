require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do  
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it_behaves_like "Voted"

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
      it 'redirects to show view' do
        post :create, params: valid_params
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalids attributes' do
      it 're-renders new view' do
        post :create, params: invalid_params, format: :js
        expect(response).to render_template :create
      end
    end

    it_behaves_like 'Savable' do
      let(:model) { Question }
    end
  end

  describe 'PATCH #update' do
    it_behaves_like 'Updatable' do
      let(:model) { :question }
      let(:object) { question }
    end
  end

  describe 'DELETE #destroy' do
    let (:author) { create(:user) }
    let!(:question) { create(:question, user: author) }

    context 'User is author' do
      before { login(author) }
      
      it 'redirects to show' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'User is not author' do
      before { login(user) }

      it 'redirects to root' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end

    it_behaves_like 'Destroyed' do
      let(:klass) { :question }
      let(:object) { question }
      let(:model) { Question }
    end
  end

  private
 
  def valid_params
    { question: attributes_for(:question), user: user}
  end

  def invalid_params
    { question: attributes_for(:question, :invalid), user: user}
  end 
end
