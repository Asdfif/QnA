module VotesHelper
  def vote_for_resource(resource)
    if resource.is_a?(Answer)
      vote_for_answer_path(resource)
    elsif resource.is_a?(Question)
      vote_for_question_path(resource)
    end
  end

  def vote_against_resource(resource)
    if resource.is_a?(Answer)
      vote_against_answer_path(resource)
    elsif resource.is_a?(Question)
      vote_against_question_path(resource)
    end
  end

  def cancel_vote_resource(resource)
    if resource.is_a?(Answer)
      cancel_vote_answer_path(resource)
    elsif resource.is_a?(Question)
      cancel_vote_question_path(resource)
    end
  end
end