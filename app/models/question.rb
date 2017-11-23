class Question < ApplicationRecord
  acts_as_taggable

  belongs_to :author, class_name: "User"
  has_many :answers, dependent: :delete_all

  validates_presence_of :title, :content
end
