class AddCorrectAnswerToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_reference :questions, :correct_answer
    add_foreign_key :questions, :answers, column: :correct_answer_id
  end

end
