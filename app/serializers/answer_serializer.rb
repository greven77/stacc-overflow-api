class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :content, :weighted_score,
             :created_at, :updated_at
  has_one :author

  def weighted_score
    object.weighted_score
  end
end
