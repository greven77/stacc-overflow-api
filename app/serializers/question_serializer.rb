class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :content
  has_one :author
  has_many :answers
  has_many :tags
end
