class User < ApplicationRecord
  has_secure_password
  has_many :questions, dependent: :delete_all, foreign_key: "author_id"
  has_many :answers, dependent: :delete_all

  validates_presence_of :username, :email, :password_digest
end
