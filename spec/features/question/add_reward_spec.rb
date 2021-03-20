require 'rails_helper'
feature 'User can add reward to question', %q{
  In order to thank best answer's user for my question
  As an question's author
  I'd like to be able to add reward
} do
  given(:author) { create(:user) }

  scenario 'User adds reward when asks question' do
    sign_in_and_visit_as(author)

    fill_question_fields

    fill_in "reward's Title", with: attributes_for(:reward)[:title]
    fill_in "reward's Img URL", with: attributes_for(:reward)[:img_url]

    click_on 'Ask'

    expect(page).to have_content attributes_for(:reward)[:title]
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
end