class Reward < ApplicationRecord
  belongs_to :question
  has_one :reward_owning, dependent: :destroy
  has_one :user, through: :reward_owning

  validates :img_url, presence: true, format: { with: URI::regexp }
  validates :title, presence: true
end
