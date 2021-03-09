require 'rails_helper'
feature 'User can delete answer', %q{
  I'd like to be able to delete my answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  describe 'Current user is an author' do
    background do
      sign_in_and_visit(author, question)  
    end

    scenario 'Author can delete his answer' do
      click_on 'Delete answer'

      expect(page).to have_content 'Answer deleted'
      expect(page).to_not have_content "#{attributes_for(:answer)[:body]}"
    end
  end

  describe 'Current user is not an author' do
    background do
      sign_in_and_visit(user, question)  
    end

    scenario 'Not author can not delete answer' do
      expect(page).to_not have_content 'Delete answer'
    end
  end

  describe 'Unauthorized user' do
    scenario "can't delete question" do
      visit question_path(question)
      expect(page).to_not have_content 'Delete answer'
    end
  end

  private

  def sign_in_and_visit(user, question)
    sign_in(user)
    visit question_path(question)
  end
end
