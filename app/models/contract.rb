class Contract < ApplicationRecord
  belongs_to :ship, optional: true
  belongs_to :planet, foreign_key: :origin_planet_id
  belongs_to :planet, foreign_key: :destination_planet_id

  validates :description, presence: true, length: { maximum: 255 }
  validates :origin_planet_id, presence: true
  validates :destination_planet_id, presence: true
  validates :completed_at, comparison: { greater_than_or_equal_to: Time.zone.now }, allow_nil: true
  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def complete!
    update!(completed_at: Time.zone.now)
  end
end
