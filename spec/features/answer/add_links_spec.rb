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
    sign_in_and_visit_as(author)

    fill_in :answer_body, with: attributes_for(:answer)[:body]

    fill_link_fields(url)

    click_on 'Send answer'

    within '.answers' do
      expect(page).to have_link url, href: url
    end
  end

  scenario 'User adds links when give an answer', js: true do
    url2 = 'http://google.ru'
    sign_in_and_visit_as(author)

    fill_in :answer_body, with: attributes_for(:answer)[:body]

    fill_link_fields(url)

    click_on 'add link'

    within all(:css, '.nested-fields')[0] do
      fill_link_fields(url2)
    end

    click_on 'Send answer'

    within '.answers' do
      expect(page).to have_link url, href: url
      expect(page).to have_link url2, href: url2
    end
  end

  private
  
  def sign_in_and_visit_as(user)
    sign_in(user)
    visit question_path(question)
  end

  def fill_link_fields(url)
    fill_in 'Link name', with: url
    fill_in 'Url', with: url
  end
end