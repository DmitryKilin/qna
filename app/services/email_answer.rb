class Services::EmailAnswer
  def send_answer(answer)
    answer.question.subscriptions.find_each do |subscription|
      SubscriptionMailer.send_answer(answer, subscription.user).deliver_later
    end
  end
end