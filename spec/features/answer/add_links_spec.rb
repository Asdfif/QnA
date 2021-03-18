require 'rails_helper'
feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add link
} do
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:url) { 'https://github.com/Asdfif/QnA/pull/5' }


  scenario 'User adds link when give an answer', js: true do
    sign_in(author)
    visit question_path(question)

    fill_in :answer_body, with: attributes_for(:answer)[:body]

    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: url

    click_on 'Send answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: url
    end
  end
end