FactoryBot.define do
  factory :transaction do
    description { Faker::Lorem.sentence }
    certification { Pilot.generate_valid_certification }
    amount { 100 }
    kind { %w[credit debit].sample }
    contract
  end
end
