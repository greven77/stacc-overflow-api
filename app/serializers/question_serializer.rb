class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :votes, :correct_answer_id,
             :created_at, :updated_at, :author, :tags, :answer_count
  attribute :answers, if: :thread? do
    sorted_by = @instance_options[:thread][:sorted_by]
    page = @instance_options[:thread][:page]
    answers = object.answers
                .sortedBy(sorted_by)
                .page(page)
                .per_page(30)
    @instance_options[:answers] = answers
    ActiveModelSerializers::SerializableResource.new(answers).serializer_instance
  end

  attribute :user_votes, if: :thread?
  #has_one :author
  has_many :answers, unless: :thread?
  #has_many :tags
  attribute :answer_ids, if: :thread? do
    @instance_options[:answers].pluck(:id)
  end


  def votes
    object.cached_weighted_score
  end

  def answer_count
    object.answers.count
  end

  def author
    UserSerializer.new(object.author).attributes
  end

  def thread?
    @instance_options[:thread] ?
      @instance_options[:thread][:display]
      : false
  end

  def user_votes
    @instance_options[:thread][:user_votes]
  end

#  def attributes
#    data = super
#    if scope
#      scope.split(",").each do |field|
#        if field == 'answers' && thread?
#          data[:answers] = ActiveModelSerializers::SerializableResource.new(object.answers)
#        end
#      end
#    end
#  end
end
