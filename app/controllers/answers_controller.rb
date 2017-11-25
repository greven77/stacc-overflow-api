class AnswersController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show]

  before_action :set_question
  before_action :set_question_answer, only: [:show, :update, :destroy, :vote]

  def index
    sort_param = params[:sort] || "id"
    dir_param = params[:sort_dir] || "ASC"
    answers = @question.answers.order(sort_param => dir_param)
    #json_response(@question.answers)
    paginate json: answers, status: :ok, per_page: 20
  end

  def show
    json_response(@answer)
  end

  def create
    ap = answer_params
    ap["user_id"] = current_user.id
    @question.answers.create!(ap)
    json_response(@question, :created)
  end

  def update
    authorize @answer, :update?
    if @answer.update(answer_params)
      json_response(@answer)
    else
      json_response(@answer.errors, :unprocessable_entity)
    end
  end

  def destroy
    authorize @answer, :destroy?
    @answer.destroy
    head :no_content
  end

  def vote
    authorize @answer, :vote?
    vote = @answer.votes.find_or_create_by(user_id: current_user.id)
    if vote.update_attributes(vote_value: params[:vote_value])
      json_response(@answer)
    else
      json_response(vote.errors, :unprocessable_entity)
    end
  end

  private

  def answer_params
    params.permit(:content, :user_id, :vote_value,
                  :id, :question_id, :sort, :sort_dir)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_question_answer
    @answer = @question.answers.find_by!(id: params[:id]) if @question
  end
end
