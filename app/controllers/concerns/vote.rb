module Vote
  def doVote(object, user, vote_value)
    vote = case vote_value
    when '-1'
      object.vote_from user
    when '0'
      object.unliked_by user
    when '1'
      object.downvote_from user
    else
      false
    end

    vote ?
      (head :no_content) :
      (render json: { error: "invalid value" }, status: :unprocessable_entity)
  end
end
