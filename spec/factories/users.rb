FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    role { "employee" }

    trait :employee do
      role { "employee" }
    end

    trait :reviewer do
      role { "reviewer" }
    end
  end
end
