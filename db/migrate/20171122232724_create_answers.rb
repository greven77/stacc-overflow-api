class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.text :content
      t.references :author, index: true
      t.references :question, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_foreign_key :answers, :users, column: :author_id
  end
end
