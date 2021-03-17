require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'PATCH #delete_file' do
    before do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb', content_type: 'rb')
    end
    context 'User is an author of resource' do
      it "deletes resource's file" do
        login(user)
        delete :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js

        expect(question.files.all).to be_empty
      end
    end

    context 'User is not an author of resource' do
      let(:not_author) { create(:user) }
      it "does not deletes resource's file" do
        login(not_author)
        delete :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js

        expect(question.files.all).to_not be_empty
      end
    end

    context 'Unauthenticated user' do
      it "does not deletes resource's file" do
        delete :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js

        expect(question.files.all).to_not be_empty
      end
    end
  end
end
