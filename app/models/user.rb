class User < ApplicationRecord
  has_secure_password
  has_many :questions, dependent: :delete_all, foreign_key: "author_id"
  has_many :answers, dependent: :delete_all

  mount_uploader :profile_pic, ProfilePicUploader

  validates_presence_of :username, :email, :password_digest
end
