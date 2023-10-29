class Transaction < ApplicationRecord
  belongs_to :contract, optional: true

  validates :certification, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :kind, presence: true, inclusion: { in: %w[credit debit] }
end
