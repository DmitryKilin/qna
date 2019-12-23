class SubscriptionMailer < ApplicationMailer
  def send_answer(answer, user)
    @answer = answer
    @question = answer.question
    mail to: user.email, subject: 'QnA subscription.'
  end
end
