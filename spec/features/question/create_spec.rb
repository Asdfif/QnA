require 'rails_helper'
feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  given(:user) { create(:user) }

  describe 'Authenticate user', js: true do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'Authenticated user asks a question' do 
      question_title = attributes_for(:question)[:title]
      question_body = attributes_for(:question)[:body]
      fill_in 'Title', with: question_title
      fill_in 'Body', with: question_body
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content question_title
      expect(page).to have_content question_body
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content ('error' || 'errors')
    end

    scenario 'asks a question with attached files' do
      question_title = attributes_for(:question)[:title]
      question_body = attributes_for(:question)[:body]
      fill_in 'Title', with: question_title
      fill_in 'Body', with: question_body

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  describe 'multiple sessions', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)

        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'qTitle'
        fill_in 'Body', with: 'qBody'
        click_on 'Ask'
        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'qTitle'
        expect(page).to have_content 'qBody'
      end

      Capybara.using_session('guest') do
        expect(page).to have_link 'qTitle'
      end
    end
  end
end
