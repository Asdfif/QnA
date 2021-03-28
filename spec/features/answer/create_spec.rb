require 'rails_helper'
feature 'User can create answer', %q{
  In order to give answer to a community
  I'd like to be able to give the answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticate user', js: true  do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'valid answer' do 
      fill_in :answer_body, with: 'answer text'
      click_on 'Send answer'
      
      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'answer text'
    end

    scenario 'answer the question with errors'do
      click_on 'Send answer'
      
      expect(page).to have_content 'error(s)'
    end

    scenario 'give an answer with attached files' do
      fill_in :answer_body, with: 'answer text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Send answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)
    fill_in :answer_body, with: 'answer text'
    click_on 'Send answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  describe 'multiple sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        
        fill_in :answer_body, with: 'answer text'
        click_on 'Send answer'
        
        expect(current_path).to eq question_path(question)
        expect(page).to have_content 'answer text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'answer text'
      end
    end
  end
end
