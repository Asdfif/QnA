require 'rails_helper'
feature 'User can view questions list', %q{
  In order to check questions from a community
  I'd like to be able to view questions list
} do
  let (:author) { create(:user) }
  let! (:questions) { create_list(:question, 2 , user: author) }

  scenario 'User view questions list' do
    visit questions_path
    questions.map do |question|
      expect(page).to have_content question.title
    end
  end
end
