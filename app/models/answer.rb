class Answer < ApplicationRecord
  acts_as_votable

  scope :oldest, -> { order(:created_at => :asc) }

  scope :most_voted, -> { order(:cached_weighted_score => :desc) }

  belongs_to :author, class_name: "User"
  belongs_to :question

  validates_presence_of :content

  def self.sortedBy(keyword)
    case keyword
    when "votes"
      self.most_voted
    when "oldest"
      self.oldest
    else
      false
    end
  end
end
