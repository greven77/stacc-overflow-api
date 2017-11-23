class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :content, :total_votes, :username

  def total_votes
    object.total_votes
  end

  def username
    object.user.username
  end
end
