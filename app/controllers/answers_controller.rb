class AnswersController < ApplicationController
  before_action :set_question
  before_action :set_question_answer, only: [:show, :update, :destroy]

  def index
    #json_response(@question.answers)
    paginate json: @question.answers, status: :ok, per_page: 20
  end

  def show
    json_response(@answer)
  end

  def create
    @question.answers.create!(answer_params)
    json_response(@question, :created)
  end

  def update
    @answer.update(answer_params)
    head :no_content
  end

  def destroy
    @answer.destroy
    head :no_content
  end

  private

  def answer_params
    params.permit(:content, :user_id)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_question_answer
    @answer = @question.answers.find_by!(id: params[:id]) if @question
  end
end
