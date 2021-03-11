require 'rails_helper'
feature 'User can edt his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  
  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    scenario 'edit his answer' do
      sign_in(author)
      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in :answer_body, with: 'edited answer'
        click_on 'Edit answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' 

    scenario "tries to edit other user's answer" 
  end

end