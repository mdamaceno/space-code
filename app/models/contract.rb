class Contract < ApplicationRecord
  belongs_to :ship, optional: true
  belongs_to :planet, foreign_key: :origin_planet_id, inverse_of: :origin_contracts
  belongs_to :planet, foreign_key: :destination_planet_id, inverse_of: :destination_contracts

  has_many :payload, dependent: :destroy, class_name: "Resource"

  validates :description, presence: true, length: { maximum: 255 }
  validates :origin_planet_id, presence: true
  validates :destination_planet_id, presence: true
  validates :completed_at, comparison: { greater_than_or_equal_to: Time.zone.now }, allow_nil: true
  validates :value, presence: true, numericality: { greater_than: 0 }

  scope :incomplete, -> { where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }

  def complete!
    raise CustomErrors::ContractAlreadyCompletedError unless completed_at.nil?
    raise CustomErrors::ContractWithoutShipError if ship_id.nil?

    if completed_at.nil? && ship.pilot.planet_id != destination_planet_id
      raise CustomErrors::PilotNotInDestinationPlanetError
    end

    ActiveRecord::Base.transaction do
      update!(completed_at: Time.zone.now)
      Transaction.send_credit(ship.pilot, value, "Contract #{id} paid: -₭#{value}", id)
    end
  end
end
