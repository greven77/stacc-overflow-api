class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :weighted_score
  has_one :author
  has_many :answers
  has_many :tags

  def weighted_score
    object.weighted_score
  end
end
