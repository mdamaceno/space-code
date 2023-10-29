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
    ActiveRecord::Base.transaction do
      fuel_cost = Route.fuel_cost(self.location, planet)
      ship.update!(fuel_level: ship.fuel_level - fuel_cost)
      self.update!(planet: planet)
    end
  end
end
