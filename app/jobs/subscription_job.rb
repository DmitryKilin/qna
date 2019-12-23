class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::EmailAnswer.new.send_answer(answer)
  end
end
