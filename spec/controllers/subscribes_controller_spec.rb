require 'rails_helper'

RSpec.describe SubscribesController, type: :controller do

  describe 'POST #create' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }

    it 'subscribes to question' do
      login(user)
      post :create, params: { question_id: question }
      expect(question.subscribers.count).to eq 1
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:subscribe) { create(:subscribe, question: question, subscriber: user) }

    it 'unsubscribes from question' do
      login(user)
      delete :destroy, params: { id: subscribe }
      expect(question.subscribers.count).to eq 0
    end
  end
end
