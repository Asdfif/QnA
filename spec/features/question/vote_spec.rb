require 'rails_helper'
feature 'User can vote for question', %q{
  In order to show that I like this question
  As not an author of this question
  I'd like to be able to like this question
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user can not like question' do
    visit question_path(question)

    expect(page).to_not have_link 'vote for'
    expect(page).to_not have_link 'vote against'
  end

  describe 'Authenticated user can like question', js: true do
    scenario 'Author of answer can not like his question' do
      sign_in_and_visit(author)

      expect(page).to_not have_link 'vote for'
      expect(page).to_not have_link 'vote against'
    end

    scenario 'Not an author can like other question' do
      sign_in_and_visit(user)

      within '.question' do
        click_on 'vote for'
        
        expect(page).to have_link 'cancel vote'
        expect(page).to have_content "Rating: 1"

      end
    end
  end

  private

  def sign_in_and_visit(user)
    sign_in(user)
    visit question_path(question)
  end
end
