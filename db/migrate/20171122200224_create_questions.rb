class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.references :author, index:true
 
      t.timestamps null: false
    end

    add_foreign_key :questions, :users, column: :author_id
  end
end
