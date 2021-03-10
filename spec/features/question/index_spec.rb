require 'rails_helper'
feature 'User can view questions list', %q{
  In order to check questions from a community
  I'd like to be able to view questions list
} do
  scenario 'User view questions list' do
    visit questions_path

    expect(page).to have_content 'Questions list'
    expect(page).to have_content 'Title'
  end
end
