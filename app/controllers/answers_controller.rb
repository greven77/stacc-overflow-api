class AnswersController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show]

  before_action :set_question
  before_action :set_question_answer, only: [:show, :update, :destroy, :vote]

  def index
    answers = @question.answers.sortedBy(params[:sort]) || @question.answers.oldest
    paginate json: answers, status: :ok, per_page: params[:per_page] || 20
  end

  def show
    json_response(@answer)
  end

  def create
    ap = answer_params
    ap["author_id"] = current_user.id
    answer = @question.answers.create!(ap)
    json_response(answer, :created)
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
    doVote(@answer, current_user, params[:vote_value])
  end

  private

  def answer_params
    params.permit(:content, :user_id, :vote_value,
                  :id, :question_id, :sort,
                  :per_page)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_question_answer
    @answer = @question.answers.find_by!(id: params[:id]) if @question
  end
end
