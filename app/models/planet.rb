class Planet < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 150 }
end
