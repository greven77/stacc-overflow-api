class AddCachedWeightedScoreToQuestions < ActiveRecord::Migration[5.1]
  def self.up
    add_column :questions, :cached_weighted_score, :integer, :default => 0
    add_index :questions, :cached_weighted_score
  end

  def self.down
    remove_column :questions, :cached_weighted_score
  end
end
