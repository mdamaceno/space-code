FactoryBot.define do
  factory :contract, class: Contract do
    description { "Send resource to the planet" }
    origin_planet_id { Planet.all.sample.id }
    destination_planet_id { Planet.all.sample.id }
    value { rand(100..1000) }
    ship_id { nil }
  end
end
