class QuestionsController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show, :top]

  before_action :set_question, only: [:show, :update, :destroy, :vote]

  def index
    sort_param = params[:sort] || "id"
    dir_param = params[:sort_dir] || "ASC"
    question_entity = params[:tagged_with] ? Question.tagged_with(params[:tagged_with]) : Question
    questions = question_entity.order(sort_param => dir_param)
    #json_response(questions)
    paginate json: questions, status: :ok, per_page: params[:per_page] || 20
  end

  def top
    dir_param = params[:sort_dir] || "DESC"
    questions = Question.order(:cached_weighted_score => dir_param)
    paginate json: questions, status: :ok, per_page: 15
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

  private

  def question_params
    params.permit(:title, :content, :author_id, :tag_list, :sort, :sort_dir, :tagged_with,
                  :vote_value, :per_page)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
