require 'faker'

ActsAsTaggableOn::Tag.destroy_all
Vote.destroy_all
Answer.destroy_all
Question.destroy_all
User.destroy_all

10.times do
  user = User.create(email: Faker::Internet.email, username: Faker::Internet.user_name, password: "password")
  rand(2..5).times do
    Question.create(title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph, author_id: user.id, tag_list: Faker::Lorem.words(rand(2..4)))
  end
end

def get_random_user(ids_to_exclude = nil)
  user_ids = User.pluck(:id)
  user_ids.select { |user_id| !ids_to_exclude.include?(user_id) }.sample
end

Question.all.each do |question|
  rand(2..6).times do
    question.answers.create(content: Faker::Lorem.paragraph, user_id: get_random_user([question.author_id]))
  end
end

Answer.all.each do |answer|
  rand(0..10).times do
    ids_to_exclude = answer.votes.pluck(:user_id) << answer.user_id
    random_user = get_random_user(ids_to_exclude)
    answer.votes.create(vote_value: rand(-1..1), user_id: get_random_user(ids_to_exclude)) if random_user
  end
end
