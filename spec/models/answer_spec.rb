require 'rails_helper'
RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  it "equal question's best answer when attribute best is true" do
    author = create(:user)
    question = create(:question, user: author)
    answer = create(:answer, user: author, question: question)
    answer.make_it_best

    expect(question.best_answer).to eq answer
  end
  
  it 'can be the only best answer for one question' do
    author = create(:user)
    question = create(:question, user: author)
    answer1 = create(:answer, user: author, question: question, best: true)
    answer2 = create(:answer, user: author, question: question, best: true)

    expect(question.answers.where(best: true).count).to eq 1
  end

end
