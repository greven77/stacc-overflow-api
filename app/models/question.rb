class Question < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :answers, dependent: :delete_all

  validates_presence_of :title, :content
end
