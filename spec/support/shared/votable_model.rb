RSpec.shared_examples 'votable' do
  let(:model) { create described_class.to_s.downcase.to_sym }
  let(:author) { model.user }
  let!(:user1) { create :user }
  let!(:user2) { create :user }

  it '#poll_up' do
    model.poll_up(user1)
    expect(model.amount).to eq 1
  end

  it '#poll_up as author' do
    model.poll_up(author)
    expect(model.amount).to_not eq 1
  end

  it '#poll_down' do
    model.poll_down(user1)
    expect(model.amount).to eq -1
  end

  it '#poll_down as author' do
    model.poll_down(author)
    expect(model.amount).to_not eq -1
  end

  it '#amount' do
    model.poll_up(user1)
    model.poll_up(user1)
    expect(model.amount).to eq 1

    model.poll_up(user2)
    expect(model.amount).to eq 2

    model.poll_down(user2)
    expect(model.amount).to eq 1

    model.poll_down(user2)
    model.poll_down(user2)
    expect(model.amount).to be_zero

    model.poll_down(user1)
    expect(model.amount).to eq -1
  end
end
