require 'rails_helper'

feature 'User can delete answer', %q{
  I'd like to be able to delete my answer
} do
  
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  describe 'Current user = author' do
    background do
      sign_in(author)

      visit_question_path_and_click_delete(question)
    end

    scenario 'Author can delete his answer' do
      expect(page).to have_content 'Answer deleted'
    end
  end

  describe 'Current user != author' do

    background do
      sign_in(user)
      
      visit_question_path_and_click_delete(question)
    end

    scenario 'Not author can not delete answer' do
      expect(page).to have_content "You can't to that"
    end
  end

  describe 'Unauthorized user' do
    scenario "can't delete answer" do
      visit_question_path_and_click_delete(question)
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end

  private

  def visit_question_path_and_click_delete(question)
    visit question_path(question)
    click_on 'Delete answer'
  end
end
