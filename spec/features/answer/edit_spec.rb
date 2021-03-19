require 'rails_helper'
feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given(:url) { 'https://github.com/Asdfif/QnA/pull/5' }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edit his answer' do
      sign_in_as_author
      within '.answers' do
        fill_in :answer_body, with: 'edited answer'
        click_on 'Edit answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      sign_in_as_author
      within '.answers' do
        fill_in :answer_body, with: ''
        click_on 'Edit answer'

        expect(page).to have_content 'error(s)'
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end

    scenario 'adds links to answer' do
      sign_in_as_author
      within '.answers' do
        click_on 'add link'
        fill_link_fields(url)
        click_on 'Edit answer'  
        expect(page).to have_link url, href: url
      end
    end

    scenario 'Author edits his answer with attached files' do
      sign_in_as_author
      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Edit answer'
      end
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'Autor delete attached file' do
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb', content_type: 'rb')
      sign_in_as_author

      within '.answers' do
        click_on 'Delete file'

        expect(page).to_not have_content 'rails_helper.rb'
      end
    end
  end

  private 

  def sign_in_as_author
    sign_in(author)
    visit question_path(question)
    click_on 'Edit'
  end

  def fill_link_fields(url)
    fill_in 'Link name', with: url
    fill_in 'Url', with: url
  end
end