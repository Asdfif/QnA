require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  it { should belong_to(:subscriber) }
  it { should belong_to(:question) }

  describe 'valdates uniqueness of question scoped to subscriber' do
    let(:users) { create_list(:user, 2) }
    let(:question) { create(:question, user: users.first) }

    it 'do not allow to save subscribe with same question and user' do
      Subscribe.create(question: question, subscriber: users.first)
      Subscribe.create(question: question, subscriber: users.first)
      expect(question.subscribers.count).to eq 1
    end

    it 'allow to save subscribe with different question and user' do
      Subscribe.create(question: question, subscriber: users.first)
      Subscribe.create(question: question, subscriber: users.second)
      expect(question.subscribers.count).to eq 2
    end
  end
end
