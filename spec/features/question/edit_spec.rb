require 'rails_helper'
feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:url) { 'https://github.com/Asdfif/QnA/pull/5' }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edit his question' do
      sign_in_as_author
      # save_and_open_page
      within '.questions' do
        fill_in :question_title, with: 'edited question title'
        click_on 'Edit question'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited question title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      sign_in_as_author
      within '.questions' do
        fill_in :question_body, with: ''
        click_on 'Edit question'

        expect(page).to have_content 'error(s)'
      end
    end

    scenario 'adds links to question' do
      sign_in_as_author
      click_on 'add link'
      fill_link_fields(url)
      click_on 'Edit question'
      click_on question.title
      
      expect(page).to have_link url, href: url
    end

    scenario "tries to edit other user's question" do
      sign_in(user)
      visit questions_path

      expect(page).to_not have_link 'Edit'
    end

    scenario 'Author edits a question with attached files' do
      sign_in_as_author
      within '.questions' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Edit question'
        click_on question.title
      end
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'Autor delete attached file' do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb', content_type: 'rb')
      sign_in_as_author

      within '.questions' do

        click_on 'Delete file'

        expect(page).to_not have_content 'rails_helper.rb'
      end
    end
  end

  private 

  def sign_in_as_author
    sign_in(author)
    visit questions_path
    click_on 'Edit'
  end

  def fill_link_fields(url)
    fill_in 'Link name', with: url
    fill_in 'Url', with: url
  end
end