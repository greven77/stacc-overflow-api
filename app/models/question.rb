class Question < ApplicationRecord
  acts_as_taggable
  acts_as_votable

  scope :search_import, -> { includes(:tags) }
  searchkick searchable: [:content, :title, :name_tagged]

  scope :unanswered, -> { joins(:answers)
                            .select('questions.*, COUNT(*) AS answer_count')
                            .group('id')
                            .having("answer_count = 0")}

  scope :tagged, -> { joins(:tags)
                        .select('questions.*, COUNT(*) AS tag_count')
                        .group('id')
                        .having("tag_count > 0")
                        }

  scope :week, -> { where("created_at >= ?", 1.week.ago) }

  scope :month, -> { where("created_at >= ?", 1.month.ago) }

  scope :newest, -> { order(:created_at => :desc) }

  scope :most_voted, -> { order(:cached_weighted_score => :desc) }

  belongs_to :author, class_name: "User"
  has_many :answers, dependent: :delete_all

  validates_presence_of :title, :content

  validate :valid_correct_answer_id

  def search_data
    {
      title: title,
      content: content,
      name_tagged: "#{tags.map(&:name).join(" ")}"
    }
  end

  def self.get_user_votes(current_user, question)
    {
      question: current_user.voted_for?(question),
      answers: self.get_voted_answers(question.id, current_user.id)
    }
  end

  def self.get_voted_answers(question_id, current_user_id)
    Question.joins("INNER JOIN answers ON questions.id = answers.question_id INNER JOIN votes ON votes.votable_id = answers.id WHERE questions.id = #{question_id} AND votes.voter_id = #{current_user_id}").
      select('questions.id AS question_id, answers.id AS votable_id, votes.vote_flag').
      map { |vote| vote.slice("votable_id", "vote_flag") }
  end

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

  def valid_correct_answer_id
    return if correct_answer_id.nil?
    answers.find(correct_answer_id)
  rescue ActiveRecord::RecordNotFound
    errors.add(:correct_answer_id, "invalid answer id")
  end
end
