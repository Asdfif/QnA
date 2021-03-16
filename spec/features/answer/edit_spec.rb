require 'rails_helper'
feature 'User can edit his answer', %q{
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
      sign_in_as_author
      within '.answers' do
        fill_in :answer_body, with: 'edited answer'
        click_on 'Edit answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      sign_in_as_author
      within '.answers' do
        fill_in :answer_body, with: ''
        click_on 'Edit answer'

        expect(page).to have_content 'error(s)'
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end

  private 

  def sign_in_as_author
    sign_in(author)
    visit question_path(question)
    click_on 'Edit'
  end
end