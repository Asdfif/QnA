require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticate user' do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'valid answer' do 
      fill_in :answer_body, with: 'answer text'
      click_on 'Send answer'
      
      expect(page).to have_content 'answer text'
      expect(page).to have_content 'Your answer'
      expect(page).to have_button 'Send answer'
    end

    scenario 'answer the question with errors' do
      click_on 'Send answer'
      
      expect(page).to have_content ('error' || 'errors')
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
