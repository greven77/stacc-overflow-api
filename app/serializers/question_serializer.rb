class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :weighted_score, :correct_answer_id,
             :created_at, :updated_at, :author, :tags, :answer_count
  #has_one :author
  has_many :answers
  #has_many :tags

  def weighted_score
    object.cached_weighted_score
  end

  def answer_count
    object.answers.count
  end

  def author
    UserSerializer.new(object.author).attributes
  end
end
