require 'rails_helper'

feature 'User can register', %q{
  In order to ask questions and create answers
  As an unregistred user
  I'd like to be able to register
} do

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up wth valid params' do
    fill_in 'Email', with: attributes_for(:user)[:email]
    fill_in 'Password', with: attributes_for(:user)[:password]
    fill_in 'Password confirmation', with: attributes_for(:user)[:password_confirmation]
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up with invalid params' do
    fill_in 'Email', with: 'wrong'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '123'
    click_on 'Sign up'

    expect(page).to have_content ('error' || 'errors')
  end
end