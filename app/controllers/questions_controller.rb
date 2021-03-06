class QuestionsController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show, :top, :search, :tagged, :tag_cloud, :thread]

  before_action :set_question, only: [:show, :update, :destroy, :vote, :thread]

  before_action :set_user_votes, only: [:thread]

  def index
    questions = Question.sortedBy(params[:sort]) || Question.most_voted
    per_page = params[:per_page] || 15
    paginated_questions = paginate questions, per_page: per_page
    render json: paginated_questions, status: :ok,
             meta: { total: Question.count, ids: paginated_questions.map(&:id) }
  end

  # can be ordered by votes, newest and unanswered
  def tagged
    per_page = params[:per_page] || 15
    tagged_questions = paginate Question.tagged_with(params[:tagged_with])
                                  .sortedBy(params[:sort]), per_page: per_page
    render json: tagged_questions, status: :ok,
             meta: { total: Question.tagged_with(params[:tagged_with]).count,
                     ids: tagged_questions.map(&:id)
                   }
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

  def thread
    total = @question.answers.count
    response.set_header("total", total)
    response.set_header("per-page", 30)
    response.set_header("x-page", params[:page] || 1)
    render json: @question, thread: { display: true, sorted_by: params[:sort],
                                      page: params[:page], user_votes: @user_votes.as_json},
             status: :ok, meta: { total: total }
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
    response.set_header("per-page", params[:per_page] || 40)
    response.set_header("x-page", params[:page] || 1)
    questions = Question.search params[:search], page: params[:page],
                                per_page: params[:per_page], order: sortedSearch(params[:sort])
    total = questions.total_count
    response.set_header("total", total)
    render json: questions, meta: { total: total, ids: questions.map(&:id)}
  end

  private

  def question_params
    params.permit(:title, :content, :author_id, :sort, :sort_dir,
                  :tagged_with, :type,:vote_value, :per_page,
                  :correct_answer_id, :search, :tag_list => [])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def set_user_votes
    user = get_user
    @user_votes = user ? Question.get_user_votes(user, @question) : ""
  end

  def get_user
    if current_user
      current_user
    elsif request.headers['Authorization']
       user_id = JsonWebToken.decode(request.headers['Authorization'])["user_id"]
       User.find(user_id)
    else
      nil
    end
  end
end
