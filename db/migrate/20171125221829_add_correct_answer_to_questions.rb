class AddCorrectAnswerToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :correct_answer_id, :integer, :default => :null
  end
end
