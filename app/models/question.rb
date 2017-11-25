class Question < ApplicationRecord
  acts_as_taggable
  acts_as_votable

  scope :unanswered, -> { joins(:answers)
                            .select('questions.*, COUNT(*) AS answer_count')
                            .group('id')
                            .having("answer_count = 0")}

  scope :week, -> { where("created_at >= ?", 1.week.ago) }

  scope :month, -> { where("created_at >= ?", 1.month.ago) }

  scope :newest, -> { order(:created_at => :desc) }

  scope :most_voted, -> { order(:cached_weighted_score => :desc) }

  belongs_to :author, class_name: "User"
  has_many :answers, dependent: :delete_all

  validates_presence_of :title, :content

  def self.sortedBy(keyword, tag = "")
    case keyword
    when "votes"
      self.most_voted
    when "newest"
      self.newest
    when "newest_unanswered"
      self.unanswered.newest
    when "votes_unanswered"
      self.unanswered.most_voted
    when "top_month"
      self.month.most_voted
    when "top_week"
      self.week.most_voted
    else
      self.most_voted
    end
  end
end
