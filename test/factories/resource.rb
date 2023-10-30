FactoryBot.define do
  factory :resource, class: Resource do
    name { %w[water food minerals].sample }
    weight { rand(1..100) }
    contract { Contract.all.sample }
  end
end
