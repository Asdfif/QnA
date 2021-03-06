require 'rails_helper'
feature 'User can delete answer', %q{
  I'd like to be able to delete my answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  scenario 'Author can delete his answer', js: true do
    sign_in_and_visit(author, question)
    accept_alert do  
      click_on 'Delete answer'
    end
    expect(page).to_not have_content answer.body
  end

  scenario 'Not author can not delete answer' do
    sign_in_and_visit(user, question)        
    expect(page).to_not have_content 'Delete answer'
  end

  scenario "Unauthorized user can't delete question" do
    visit question_path(question)
    expect(page).to_not have_content 'Delete answer'
  end

  private

  def sign_in_and_visit(user, question)
    sign_in(user)
    visit question_path(question)
  end
end
