class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def update?
    record.author == user
  end

  def destroy?
    update? || record.question.author == user
  end

  def vote?
    !update?
  end
end
