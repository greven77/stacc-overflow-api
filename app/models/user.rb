class User < ApplicationRecord
  acts_as_voter
  has_secure_password
  has_many :questions, dependent: :delete_all, foreign_key: "author_id"
  has_many :answers, dependent: :delete_all, foreign_key: "author_id"

  mount_uploader :profile_pic, ProfilePicUploader

  validates_presence_of :username, :email, :password_digest
  validates_uniqueness_of :email, :username
  validates :email, :email_format => { :message => 'is not looking good' }
end
