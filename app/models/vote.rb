class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, presence: true, numericality: {
    equal: -> { -1 || 1 },
    only_integer: true
  }
  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }

  validate :voter_is_author

  private

  def voter_is_author
    if votable&.user == user
      errors.add(:user, 'can not vote for his resource')
    end
  end
end
