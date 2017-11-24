class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]

  def index
    sort_param = params[:sort] || "id"
    dir_param = params[:sort_dir] || "ASC"
    questions = Question.order(sort_param => dir_param)
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
    params.permit(:title, :content, :author_id, :tag_list, :sort, :sort_dir)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
