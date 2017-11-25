require 'faker'

ActsAsTaggableOn::Tag.destroy_all
ActsAsVotable::Vote.destroy_all
Answer.destroy_all
Question.destroy_all
User.destroy_all

10.times do
  user = User.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
                     password: "password")
  rand(2..5).times do
    Question.create(title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph,
                    author_id: user.id, tag_list: Faker::Lorem.words(rand(2..4)))
  end
end

def vote(object, user, vote_value)
  case vote_value
  when -1
    object.vote_from user
  when 0
    object.unliked_by user
  when 1
    object.downvote_from user
  else
    false
  end
end

def get_random_user(ids_to_exclude = nil)
  user_ids = User.pluck(:id)
  user_ids.select { |user_id| !ids_to_exclude.include?(user_id) }.sample
end

def create_votes_for(object, num = 10)
  rand(0..num).times do
    ids_to_exclude = object.votes_for.pluck(:voter_id) << object.author_id
    random_user_id = get_random_user(ids_to_exclude)
    if random_user_id
      random_user = User.find(random_user_id)
      vote(object, random_user, rand(-1..1))
    end
  end
end

Question.all.each do |question|
  rand(2..6).times do
    question.answers.create(content: Faker::Lorem.paragraph,
                            author_id: get_random_user([question.author_id]))
  end

  create_votes_for(question)
end

Answer.all.each { |answer| create_votes_for(answer) }
