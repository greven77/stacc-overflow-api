FactoryGirl.define do
  factory :question do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    association :author, factory: :user
  end
end
