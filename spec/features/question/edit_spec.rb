require 'rails_helper'
feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  
  scenario 'Unauthenticated user can not edit question' do
    visit questions_path
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edit his question' do
      sign_in_as_author
      within '.questions' do
        fill_in :question_title, with: 'edited question title'
        click_on 'Edit question'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited question title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      sign_in_as_author
      within '.questions' do
        fill_in :question_body, with: ''
        click_on 'Edit question'

        expect(page).to have_content 'error(s)'
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(user)
      visit questions_path

      expect(page).to_not have_link 'Edit'
    end
  end

  private 

  def sign_in_as_author
    sign_in(author)
    visit questions_path
    click_on 'Edit'
  end
end