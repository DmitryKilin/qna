require "rails_helper"

RSpec.describe SubscriptionMailer, type: :mailer do
  describe "send_answer" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:subscription) { create(:subscription, user: user, question: question) }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { SubscriptionMailer.send_answer(answer, user) }

    it "renders the headers" do
      expect(mail.subject).to eq('QnA subscription.')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end

end
