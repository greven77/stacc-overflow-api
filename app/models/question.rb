class Question < ApplicationRecord
  acts_as_taggable
  acts_as_votable

  belongs_to :author, class_name: "User"
  has_many :answers, dependent: :delete_all

  validates_presence_of :title, :content
end
