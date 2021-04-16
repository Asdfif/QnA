require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:service) { double('NotificationService') }

  let(:question) { create(:question, user: create(:user)) }

  before do
    allow(NotificationService).to receive(:new).and_return(service)
  end

  it 'calls NotificationService#notificate' do
    expect(service).to receive(:notificate).with(question)
    NotificationJob.perform_now(question)
  end
end
