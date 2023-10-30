FactoryBot.define do
  factory :ship, class: Ship do
    name { Faker::Name.name }
    fuel_capacity { rand(100..1000) }
    fuel_level { rand(0..100) }
    weight_capacity { rand(100..1000) }
    pilot { Pilot.all.sample }
  end
end
