FactoryGirl.define do
  factory :answer do
    content { Faker::Lorem.paragraph }
    association :user, factory: :user
    association :question, factory: :question
  end
end
