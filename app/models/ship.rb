class Ship < ApplicationRecord
  belongs_to :pilot

  validates :name, presence: true, length: { minimum: 3, maximum: 150 }
  validates :fuel_capacity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :fuel_level, presence: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: -> (ship) { ship.fuel_capacity.to_i },
  }
  validates :weight_capacity, presence: true
end
