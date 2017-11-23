class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :profile_pic
  has_many :questions
  has_many :answers
end
