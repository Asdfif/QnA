# frozen_string_literal: true

class Ability
  include CanCan::Ability
  
  attr_reader :user

  def initialize(user)
    @user = user
    guest_abilities
    if user
      user.admin? ? admin_abilities : user_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]

    can :create, Reward do |reward|
      user.owner_of?(reward.question)
    end

    can :create, Link do |link|
      user.owner_of?(link.linkable)
    end

    can %i[vote_for vote_against], [Question, Answer] do |votable| 
      !user.owner_of?(votable)
    end
    
    can :cancel_vote, [Question, Answer] do |votable|
      votable.votes.find_by(user_id: user.id)
    end 

    can :update, [Question, Answer], { user_id: user.id }

    can :destroy, [Question, Answer], { user_id: user.id }

    can :destroy, [Link] do |link|
      user.owner_of?(link.linkable)
    end

    can :delete_file, ActiveStorage::Attachment do |attachment|
      user.owner_of?(attachment.record)
    end

    can :make_it_best, Answer do  |answer|
      user.owner_of?(answer.question) 
    end
    
    can :rewards, User, { id: user.id }

    can %i[me others index answers], User do |profile|
      profile.id == user.id
    end
  end
end
