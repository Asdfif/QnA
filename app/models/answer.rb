class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  validates :body, presence: true

  validate :count_of_best

  accepts_nested_attributes_for :links, reject_if: :all_blank

  def make_it_best
    unless best?
      Answer.transaction do
        question.answers.update_all(best: false)
        update!(best: true)
        question.reward&.update(user: user)
      end
    end
  end

  def count_of_best
    if best? && question&.answers.where(best: true).count >= 1 && question.best_answer != self
      errors.add(:best, 'can not be more than 1 best answer for one question')
    end
  end
end
