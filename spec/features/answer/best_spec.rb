require 'rails_helper'
feature 'Author can make answer the best for his question', %q{
  In order to help to a community
  As an author
  I'd like to be able to make one of answers the best for my question
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario "When user is not author and tries to make answer the best", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link "Make it the best"
  end

  scenario "Unauthenticated user tries to make answer the best", js: true do
    visit question_path(question)

    expect(page).to_not have_link "Make it the best"
  end

  scenario 'Author make answer best for his question', js: true do
    sign_in(author)
    visit question_path(question)

    within ".answers" do
      click_on "Make it best"
    end

    within '.best-answer' do
      expect(page).to have_content answer.body
    end

    within '.answers' do
      expect(page).to_not have_content answer.body
    end
  end
end
