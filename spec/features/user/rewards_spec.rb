require 'rails_helper'
feature 'User can see his rewards', %q{
  In order to check rewards
  As an answerses author
  I'd like to be able see all my rewards
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user can see his rewards' do
    sign_in(user)
    question = create(:question, user: user)
    reward = create(:reward, question: question, user: user)
    user.reload
  
    visit rewards_user_path(user)

    expect(page).to have_content reward.title
    expect(page).to have_content question.title
  end

  scenario 'Unauthenticated user can not see rewards' do
    visit rewards_user_path(user)

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end