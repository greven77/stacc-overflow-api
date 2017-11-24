require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }
  let(:max_val) { 2**32-1 }
  it { should belong_to(:user) }
  it { should belong_to(:answer) }

  it "does not allow values greater than 1" do
    num = rand(1..max_val)
    vote = Vote.new(vote_value: num, user_id: user.id, answer_id: answer.id)
    expect(vote).not_to be_valid
  end

  it "does not allow values less than -1" do
    num = rand(-max_val..-1)
    vote = Vote.new(vote_value: num, user_id: user.id, answer_id: answer.id)
    expect(vote).not_to be_valid
  end

  it "allows values between 0 and 1" do
    num = rand(-1..1)
    vote = Vote.new(vote_value: num, user_id: user.id, answer_id: answer.id)
    expect(vote).to be_valid
  end

  it "doesn't allow answer author to vote own answer" do
    vote = Vote.new(vote_value: 1, user_id: answer.user.id, answer_id: answer.id)
    expect(vote).not_to be_valid
  end
end
