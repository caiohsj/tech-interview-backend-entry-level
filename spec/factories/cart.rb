FactoryBot.define do
  factory :cart do
    total_price { 0 }
    abandoned { false }
    last_interaction_at { Time.current }

    trait :available_to_remove do
      abandoned { true }
      last_interaction_at { 8.days.ago }
    end
  end
end