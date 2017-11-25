class Answer < ApplicationRecord
  acts_as_votable

  belongs_to :author, class_name: "User"
  belongs_to :question

  validates_presence_of :content
end
