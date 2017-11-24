class Vote < ApplicationRecord
  self.primary_keys = :user_id, :answer_id
  belongs_to :user
  belongs_to :answer

  validates :vote_value, acceptance: { accept: [-1, 0, 1] }, presence: true
  validate :user_not_equal_author

  private

  def user_not_equal_author
    @errors.add(:user, "should not be the same as author") if user.id == answer.user.id
  end
end
