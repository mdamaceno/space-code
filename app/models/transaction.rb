class Transaction < ApplicationRecord
  belongs_to :contract, optional: true

  validates :certification, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :kind, presence: true, inclusion: { in: %w[credit debit] }

  scope :credits, -> { where(kind: 'credit') }
  scope :debits, -> { where(kind: 'debit') }
  scope :for_certification, ->(certification) { where(certification: certification) }

  def self.pilot_credit(pilot, amount, description = nil)
    description = "Credit for #{pilot.name}: -₭#{amount}" if description.nil?
    self.create!(amount: amount, kind: 'debit', certification: pilot.certification, description: description)
  end
end
