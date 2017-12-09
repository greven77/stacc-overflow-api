class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :profile_pic
  has_many :questions, unless:  :signin?
  has_many :answers, unless: :signin?

  def signin?
    @instance_options[:signin]
  end
end
