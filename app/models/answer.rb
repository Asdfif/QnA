class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  validates :body, presence: true

  def belongs_to_user?(current_user)
    self.user == current_user
  end
end
