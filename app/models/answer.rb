class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  validates :body, presence: true

  validate :count_of_best

  def make_it_best
    question.answers.each do |answer|
      answer.update(best: false)
    end
    update(best: true)
  end

  def count_of_best
    if best && question.answers.where(best: true).count >= 1
      update(best: false)
    end
  end
end
