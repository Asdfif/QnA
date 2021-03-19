require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe 'DELETE #destroy' do
    before do
      question.links.build(name: attributes_for(:link)[:name], url: attributes_for(:link)[:url]).save
    end

    context 'User is an author of resource' do
      it "deletes resource's link" do
        login(author)
        delete :destroy, params: { id: question.links.first }, format: :js

        expect(question.links.all).to be_empty
      end
    end

    context 'User is not an author of resource' do
      it "does not deletes resource's link" do
        login(user)
        delete :destroy, params: { id: question.links.first }, format: :js

        expect(question.links.all).to_not be_empty
      end
    end

    context 'Unauthenticated user' do
      it "does not deletes resource's link" do
        delete :destroy, params: { id: question.links.first }, format: :js

        expect(question.links.all).to_not be_empty
      end
    end
  end
end
