require 'rails_helper'
feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add link
} do
  given(:author) { create(:user) }
  given(:url) { 'https://github.com/Asdfif/QnA/pull/5' }


  scenario 'User adds link when asks question' do
    sign_in(author)
    visit new_question_path

    fill_in 'Title', with: attributes_for(:question)[:title]
    fill_in 'Body', with: attributes_for(:question)[:body]

    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'My link', href: url

  end
end