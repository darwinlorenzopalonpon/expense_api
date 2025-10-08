FactoryBot.define do
  factory :expense do
    amount { Faker::Number.number(digits: 5) }
    description { Faker::Lorem.sentence }
    employee { association :user, :employee }
    state { "drafted" }

    trait :drafted do
      state { "drafted" }
    end

    trait :submitted do
      state { "submitted" }
      submitted_at { Time.current }
    end

    trait :approved do
      state { "approved" }
      reviewed_at { Time.current }
    end

    trait :rejected do
      state { "rejected" }
      reviewed_at { Time.current }
    end
  end
end
