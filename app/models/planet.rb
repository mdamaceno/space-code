class Planet < ApplicationRecord
  include Seller

  has_many :origin_routes, class_name: "Route", foreign_key: :origin_planet_id, inverse_of: :planet, dependent: :destroy
  has_many :destination_routes, class_name: "Route", foreign_key: :destination_planet_id, inverse_of: :planet, dependent: :destroy
  has_many :origin_contracts, class_name: "Contract", foreign_key: :origin_planet_id, inverse_of: :planet, dependent: :destroy
  has_many :destination_contracts, class_name: "Contract", foreign_key: :destination_planet_id, inverse_of: :planet, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 150 }
end
