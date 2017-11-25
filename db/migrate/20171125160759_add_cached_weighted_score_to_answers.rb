class AddCachedWeightedScoreToAnswers < ActiveRecord::Migration[5.1]
  def self.up
    add_column :answers, :cached_weighted_score, :integer, :default => 0
    add_index :answers, :cached_weighted_score
  end

  def self.down
    remove_column :answers, :cached_weighted_score
  end

end
