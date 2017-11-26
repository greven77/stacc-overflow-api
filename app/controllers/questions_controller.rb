class QuestionsController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show, :top, :search, :tagged, :tag_cloud]

  before_action :set_question, only: [:show, :update, :destroy, :vote]

  def index
    questions = Question.sortedBy(params[:sort]) || Question.most_voted
    paginate json: questions, status: :ok, per_page: params[:per_page] || 15
  end

  # can be ordered by votes, newest and unanswered
  def tagged
    tagged_questions = Question.tagged_with(params[:tagged_with])
    sorted_tagged_questions = tagged_questions.sortedBy(params[:sort])
    paginate json: sorted_tagged_questions, status: :ok, per_page: params[:per_page] || 15
  end

  def create
    qp = question_params
    qp["author_id"] = current_user.id
    question = Question.create!(qp)
    json_response(question, :created)
  end

  def show
    json_response(@question)
  end

  def update
    authorize @question, :update?
    @question.update(question_params)
    head :no_content
  end

  def destroy
    authorize @question, :destroy?
    @question.destroy
    head :no_content
  end

  def tag_cloud
    json_response(ActsAsTaggableOn::Tag.most_used)
  end

  def vote
    authorize @question, :vote?
    doVote(@question, current_user, params[:vote_value])
  end

  def search
    questions = Question.search params[:search], page: params[:page], per_page: params[:per_page]
    json_response(questions)
  end

  private

  def question_params
    params.permit(:title, :content, :author_id, :tag_list, :sort, :sort_dir, :tagged_with,
                  :vote_value, :per_page, :correct_answer_id, :search)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
