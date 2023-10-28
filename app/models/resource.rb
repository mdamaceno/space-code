class Resource < ApplicationRecord
  belongs_to :contract

  validates :name, presence: true, inclusion: { in: %w[minerals food water] }
  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
