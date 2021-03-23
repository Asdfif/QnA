require 'rails_helper'
feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add link
} do
  given(:author) { create(:user) }
  given(:url) { 'https://yandex.ru/' }


  scenario 'User adds link when asks question' do
    sign_in_and_visit_as(author)

    fill_question_fields

    fill_link_fields(url)

    click_on 'Ask'

    expect(page).to have_link url, href: url
  end

  scenario 'User adds links when asks question', js: true do
    url2 = 'http://google.ru'
    sign_in_and_visit_as(author)

    fill_question_fields

    fill_link_fields(url)
    
    click_on 'add link'

    within all(:css, '.nested-fields')[1] do
      fill_link_fields(url2)
    end

    click_on 'Ask'

    expect(page).to have_link url, href: url
    expect(page).to have_link url2, href: url2
  end

  private

  def sign_in_and_visit_as(user)
    sign_in(user)
    visit new_question_path
  end

  def fill_question_fields
    fill_in 'Title', with: attributes_for(:question)[:title]
    fill_in 'Body', with: attributes_for(:question)[:body]
  end

  def fill_link_fields(url)
    fill_in 'Link name', with: url
    fill_in 'Url', with: url
  end
end