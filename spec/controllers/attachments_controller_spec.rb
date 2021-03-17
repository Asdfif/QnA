require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'PATCH #delete_file' do
    before do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb', content_type: 'rb')
    end

    it "Author deletes question's file" do
      login(user)
      delete :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js

      expect(question.files.all).to be_empty
    end

    it "Not an author deletes question's file" do
      delete :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js

      expect(question.files.all).to_not be_empty
    end
  end
end
