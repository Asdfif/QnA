require 'rails_helper'

RSpec.describe NotificationService do 
  let(:subscribers) { create_list(:user, 2) }
  let!(:question) { create(:question, user: create(:user)) }
  let!(:answer) { create(:answer, question: question, user: create(:user)) }

  it 'sends notification to author of question' do
    Subscribe.create(question: question, subscriber: subscribers.first)
    Subscribe.create(question: question, subscriber: subscribers.second)
    expect(NotificationMailer).to receive(:notification).with(question).and_call_original
    subject.notificate(question)
  end
end