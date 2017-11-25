class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :content, :weighted_score
  has_one :author

  def weighted_score
    object.weighted_score
  end
end
