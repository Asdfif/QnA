require 'rails_helper'
feature 'User can subscribe question', %q{
  I'd like to be able to subscribe this question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authorized user' do
    scenario 'can subscribe question' do
      sign_in(user)

      visit question_path(question)

      click_on 'Subscribe'

      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'can unsubscribe question' do
      sign_in(user)
      visit question_path(question)

      click_on 'Subscribe'
      click_on 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
    end
  end

  describe 'Unauthorized user' do
    scenario "can't subscribe this question" do
      visit question_path(question)
      expect(page).to_not have_content 'Subscribe'
    end
  end
end
