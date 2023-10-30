FactoryBot.define do
  factory :planet, class: Planet do
    name { Faker::Name.name }
  end
end
