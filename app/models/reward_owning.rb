class RewardOwning < ApplicationRecord
  belongs_to :reward
  belongs_to :user
end
