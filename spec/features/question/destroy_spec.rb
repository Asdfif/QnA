require 'rails_helper'
feature 'User can delete question', %q{
  I'd like to be able to delete my question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Current user is an author' do
    background do
      sign_in(author)

      visit question_path(question)
      click_on 'Delete question'
    end

    scenario 'Author can delete his question' do
      expect(page).to have_content 'Question deleted'
      expect(page).to_not have_content question.body
    end
  end

  describe 'Current user is not an author' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'Not author can not delete question' do
      expect(page).to_not have_content 'Delete question'
    end
  end

  describe 'Unauthorized user' do
    scenario "can't delete question" do
      visit question_path(question)
      expect(page).to_not have_content 'Delete question'
    end
  end
end
