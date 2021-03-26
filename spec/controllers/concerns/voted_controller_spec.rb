require 'spec_helper'

shared_examples_for "voted" do
  let(:author) { create(:user) }
  let(:user) { create(:user) }

  klass = described_class.controller_path.singularize.to_sym

  case klass
  when :question
    let!(:votable) { create(klass, user: author) }
  when :answer
    let(:question) { create(:question, user: author) }
    let!(:votable) { create(klass, user: author, question: question) }
  end

  describe "POST #vote_for" do
    before { login(user) }

    it 'creates a vote with +1 value' do
      expect{ post :vote_for, params: { id: votable }, format: :json }.to change(votable.votes.where(value: 1), :count).by(1)
    end
  end

  describe "POST #vote_against" do
    before { login(user) }

    it 'creates a vote with 1 value' do
      expect{ post :vote_against, params: { id: votable }, format: :json }.to change(votable.votes.where(value: -1), :count).by(1)
    end
  end

  describe "DELETE #vote_against" do
    before do
      login(user)
      post :vote_against, params: { id: votable }, format: :json
    end

    it 'creates a vote with +1 value' do
      expect{ delete :cancel_vote, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(-1)
    end
  end
end
