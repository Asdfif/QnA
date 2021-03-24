module Voted 
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_for vote_against cancel_vote]
  end

  def vote_for
    save_vote(1)
  end

  def vote_against
    save_vote(-1)
  end

  def cancel_vote
    @votable.votes.find_by(user_id: current_user.id)&.destroy
    respond_to do |format|
      format.json { render json: [@votable.rating, @votable.class.to_s.underscore, @votable.id] }
    end
  end

  private
  
  def save_vote(value)
    @vote = @votable.votes.build(value: value, user_id: current_user.id)
    respond_to do |format|
      if @vote.save
        format.json { render json: [@votable.rating, @votable.class.to_s.underscore, @votable.id] }
      else
        format.json { render json: [@vote.errors.full_messages, @votable.class.to_s.underscore, @votable.id], status: :unprocessable_entity  }
      end
    end
  end

  def set_votable
    @votable ||= model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
