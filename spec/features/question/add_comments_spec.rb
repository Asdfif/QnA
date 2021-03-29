require 'rails_helper'
feature 'User can add comments to question', %q{
  In order to help to community
  As an authorized user
  I'd like to be able to add comment
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:comment) { 'comment' }

  scenario 'Authorized user adds comments', js: true do
    sign_in_and_visit_as(user)
    fill_in :comment_body, with: comment
    click_on 'Send comment'
  
    expect(page).to have_content comment
  end

  scenario 'Unauthorized user tries to add comments', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Send comment'
  end

  describe 'multiple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in_and_visit_as(user)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in :comment_body, with: comment
        click_on 'Send comment'
        expect(page).to have_content comment
      end

      Capybara.using_session('guest') do
        expect(page).to have_content comment
      end
    end
  end
  private

  def sign_in_and_visit_as(user)
    sign_in(user)
    visit question_path(question)
  end
end
