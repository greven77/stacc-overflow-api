class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :vote_value, null: false
      t.references :user, foreign_key: true
      t.references :answer, foreign_key: true, index: true
    end

    execute "ALTER TABLE votes ADD CONSTRAINT votes_value_check CHECK (vote_value = 1 OR vote_value = -1)"
  end
end
