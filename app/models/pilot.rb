class Pilot < ApplicationRecord
  include Certificatable

  validates :name, presence: true, length: { minimum: 3, maximum: 150 }
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 18 }
end
