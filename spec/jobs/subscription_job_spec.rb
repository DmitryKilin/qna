require 'rails_helper'

RSpec.describe SubscriptionJob, type: :job do
  let(:service) { double('Services::EmailAnswer') }
  let(:answer) { create(:answer) }
  before do
    allow(Services::EmailAnswer).to receive(:new).and_return(service)
  end
  it 'calls EmailAnswer#send_answer' do
    expect(service).to receive(:send_answer)
    SubscriptionJob.perform_now(answer)
  end
end
