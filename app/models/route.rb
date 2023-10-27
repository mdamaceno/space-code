class Route < ApplicationRecord
  belongs_to :planet, foreign_key: :origin_planet_id, inverse_of: :origin_routes
  belongs_to :planet, foreign_key: :destination_planet_id, inverse_of: :destination_routes

  validates :origin_planet_id, presence: true
  validates :destination_planet_id, presence: true
  validates :fuel_cost, numericality: { greater_than_or_equal_to: 0 }
  validate :validates_origin_and_destination_planet_not_equal

  private

  def validates_origin_and_destination_planet_not_equal
    errors.add(:destination_planet_id, :equal_to) if origin_planet_id == destination_planet_id
  end
end
