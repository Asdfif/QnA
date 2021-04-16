require 'rails_helper'

RSpec.describe NotificationService do 
  let(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: create(:user)) }

  it 'sends notification to author of question' do
    expect(NotificationMailer).to receive(:notification).with(author).and_call_original
    subject.notificate(question)
  end
end