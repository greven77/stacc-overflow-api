class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]

  def index
    questions = Question.all
    #json_response(questions)
    paginate json: questions, status: :ok, per_page: 20
  end

  def create
    question = Question.create!(question_params)
    json_response(question, :created)
  end

  def show
    json_response(@question)
  end

  def update
    @question.update(question_params)
    head :no_content
  end

  def destroy
    @question.destroy
    head :no_content
  end

  private

  def question_params
    params.permit(:title, :content, :author_id)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
