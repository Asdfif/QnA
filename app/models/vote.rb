class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, presence: true, inclusion: { in: [1, -1], message: "is invalid. It must be -1 or 1" }

  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }

  validate :voter_is_author

  private

  def voter_is_author
    if votable && user.owner_of?(votable)
      errors.add(:user, 'can not vote for his resource')
    end
  end
end
