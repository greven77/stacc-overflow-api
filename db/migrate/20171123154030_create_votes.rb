class CreateVotes < ActiveRecord::Migration[5.1]
  def change
#    create_table :votes do |t|
#      t.integer :vote_value, null: false
#      t.references :user, foreign_key: true
#      t.references :answer, foreign_key: true, index: true
#    end

    execute "CREATE TABLE `votes` (
      `vote_value` int(11) NOT NULL,
        `user_id` bigint(20) NOT NULL,
          `answer_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`, `answer_id`),
  KEY `index_votes_on_user_id` (`user_id`),
  KEY `index_votes_on_answer_id` (`answer_id`),
  CONSTRAINT `fk_rails_3f8d383c32` FOREIGN KEY (`answer_id`) REFERENCES `answers` (`id`),
  CONSTRAINT `fk_rails_c9b3bef597` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8"

    execute "ALTER TABLE votes ADD CONSTRAINT votes_value_check CHECK (vote_value = 1 OR vote_value = -1)"
  end
end
