FactoryBot.define do
  factory :pilot, class: Pilot do
    name { Faker::Name.name }
    certification { Pilot.generate_valid_certification }
    age { rand(18..99) }
    planet { Planet.all.sample }
  end
end
