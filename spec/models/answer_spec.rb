require 'rails_helper'
RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe 'Association between question and best answer' do
    let (:author) { create(:user) }
    let (:question) { create(:question, user: author) }

    it "equal question's best answer when attribute best is true" do
      answer = create(:answer, user: author, question: question)
      answer.make_it_best

      expect(question.best_answer).to eq answer
    end
    
    it 'can be the only best answer for one question' do
      answer1 = create(:answer, user: author, question: question, best: true)
      answer2 = create(:answer, user: author, question: question)
      answer2.update(best: true)

      expect(question.answers.where(best: true).count).to eq 1
    end

    it '"make it best" method changes attribute "best" from false to true' do
      answer = create(:answer, user: author, question: question)
      answer.make_it_best

      expect(answer).to be_best
    end

    it '"make it best" method changes attribute "best" from true to false in other answers' do
      answer1 = create(:answer, user: author, question: question, best: true)
      answer2 = create(:answer, user: author, question: question)
      answer2.make_it_best
      answer1.reload

      expect(answer1.best).to eq false
    end
  end
end
