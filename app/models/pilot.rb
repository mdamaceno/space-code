class Pilot < ApplicationRecord
  include Certificatable
  include Buyer

  belongs_to :planet, optional: true
  has_one :ship

  validates :name, presence: true, length: { minimum: 3, maximum: 150 }
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 18 }

  def credits
    [
      Transaction.debits.for_certification(self.certification).sum(:amount),
      Transaction.credits.for_certification(self.certification).sum(:amount) * -1,
    ].sum
  end

  def location
    planet
  end

  def location=(planet)
    self.planet = planet
  end

  def travel_to!(planet)
    route = Route.find_by(origin_planet_id: self.location&.id, destination_planet_id: planet.id)

    raise CustomErrors::RouteBlockedError if route&.blocked?

    fuel_cost = route&.fuel_cost || 0

    ActiveRecord::Base.transaction do
      ship.update!(fuel_level: ship.fuel_level - fuel_cost)
      self.update!(planet: planet)
    end
  end

  def accept_contract!(contract)
    raise CustomErrors::NoFuelError if ship.fuel_level.zero?

    contract.update!(ship_id: self.ship.id)
  end
end
