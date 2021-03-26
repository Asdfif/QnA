class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :reward_ownings, dependent: :destroy
  has_many :rewards, through: :reward_ownings
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def owner_of?(resource)
    resource.user_id == id
  end
end
