class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :votes, :correct_answer_id,
             :created_at, :updated_at, :author, :tags, :answer_count
  attribute :answers, if: :thread? do
     ActiveModelSerializers::SerializableResource.new(object.answers)
  end

  #has_one :author
  has_many :answers, unless: :thread?
  #has_many :tags

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
    @instance_options[:thread]
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
