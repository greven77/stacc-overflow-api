class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :answer

  validates :vote_value, acceptance: { accept: [-1, 0, 1] }, presence: true
end
