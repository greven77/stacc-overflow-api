class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :content, :votes,
             :created_at, :updated_at, :question_id, :author

  def votes
    object.cached_weighted_score
  end
end
