class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :reward_ownings
  has_many :rewards, through: :reward_ownings
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def owner_of?(resource)
    resource.user_id == id
  end
end
