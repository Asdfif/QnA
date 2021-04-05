module Voted 
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_for vote_against cancel_vote]
  end

  def vote_for
    authorize! :vote_for, @votable 
    save_vote(1)
  end

  def vote_against
    authorize! :vote_for, @votable
    save_vote(-1)
  end

  def cancel_vote
    authorize! :cancel_vote, @votable
    @votable.votes.find_by(user_id: current_user.id)&.destroy
    respond_to do |format|
      format.json { render json: { rating: @votable.rating, klass: @votable.class.to_s.underscore, id: @votable.id } }
    end
  end

  private

  def save_vote(value)
    @vote = @votable.votes.build(value: value, user: current_user)
    respond_to do |format|
      if @vote.save
        format.json { render json: { rating: @votable.rating, klass: @votable.class.to_s.underscore, id: @votable.id } }
      else
        format.json { render json: { errors: @vote.errors.full_messages, klass: @votable.class.to_s.underscore, id: @votable.id }, status: :unprocessable_entity  }
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
