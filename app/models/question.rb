class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def belongs_to_user?(current_user)
    self.user == current_user
  end
end
