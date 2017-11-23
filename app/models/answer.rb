class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :votes

  validates_presence_of :content

  def total_votes
    votes.inject(0) { |acc, vote| acc + vote.vote_value }
  end
end
