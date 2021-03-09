require 'rails_helper'

feature 'User can create answer', %q{
  In order to give answer to a community
  I'd like to be able to give the answer
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
    end

    scenario 'answer the question with errors' do
      click_on 'Send answer'
      
      expect(page).to have_content ('error' || 'errors')
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)
    fill_in :answer_body, with: 'answer text'
    click_on 'Send answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
