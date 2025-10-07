FactoryBot.define do
  factory :expense do
    amount { Faker::Number.number(digits: 5) }
    description { Faker::Lorem.sentence }
    employee { association :user, :employee }
    state { "drafted" }
  end
end
