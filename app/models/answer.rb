class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  validates :body, presence: true

  def make_it_best
    question.answers.each do |answer|
      answer.update(best: false)
    end
    update(best: true)
  end
end
