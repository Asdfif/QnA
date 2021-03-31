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

    can :create, [Question, Answer, Comment], { user_id: user.id }
    can :create, Link do |link|
      link.linkable.user_id == user.id
    end
    can :create, ActiveStorage::Attachment do |attachment|
      attachment.record.user_id == user.id
    end

    can :update, [Question, Answer], { user_id: user.id }

    can :destroy, [Question, Answer], { user_id: user.id }
    can :destroy, [Link] do |link|
      link.linkable.user_id == user.id
    end
    can :delete_file,ActiveStorage::Attachment do |attachment|
      attachment.record.user_id == user.id
    end
    
    can :make_it_best, Answer do  |answer| 
      answer.question.user_id == user.id
    end
  end
end
