require 'rails_helper'

feature 'User can sign out', %q{
  In order to change account
  I'd like to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Authorized user tries to sign out' do
    sign_in(user)
    visit questions_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
