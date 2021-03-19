require 'rails_helper'
feature "User can delete question's links", %q{
  In order to correct question
  As an question's author
  I'd like to be able to delete link
} do
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:link) { create(:link, linkable: question) }

  scenario "Author can delete his question's links", js: true do
    sign_in_and_visit_as(author)
    click_on 'Delete link'

    expect(page).to_not have_content link.name
  end

  scenario "Not an author can not delete answer's links", js: true do
    user = create(:user)
    sign_in_and_visit_as(user)

    expect(page).to_not have_content 'Delete link'
  end

  scenario "Unauthenticated user can not delete answer's links", js: true do
    visit question_path(question)
    
    expect(page).to_not have_content 'Delete link'
  end

  private

  def sign_in_and_visit_as(user)
    sign_in(user)
    visit question_path(question)
  end
end