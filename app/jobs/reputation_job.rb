class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    # byebug
    ReputationService.calculate(object)
  end
end
