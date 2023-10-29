class Resource < ApplicationRecord
  belongs_to :contract

  validates :name, presence: true, inclusion: { in: %w[minerals food water] }
  validates :weight, presence: true, numericality: { greater_than: 0 }
end
