require 'rails_helper'

feature 'Authenticated user can write answer for current question', %q{
  In order to community
  I'd like to be able to write answer for current question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User can write answer for question' do
    sign_in(user)
    
    visit question_path(question)

    expect(page).to have_content 'Your answer'
    expect(page).to have_button 'Send answer'
  end


end