class Transaction < ApplicationRecord
  belongs_to :contract, optional: true

  validates :certification, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :kind, presence: true, inclusion: { in: %w[credit debit] }

  scope :credits, -> { where(kind: 'credit') }
  scope :debits, -> { where(kind: 'debit') }
  scope :for_certification, ->(certification) { where(certification: certification) }

  def self.send_credit(receiver, amount, description = nil, contract_id = nil)
    description = "Credit for #{receiver.name}: -₭#{amount}" if description.nil?
    self.create!(
      amount: amount,
      kind: 'debit',
      certification: receiver.certification,
      description: description,
      contract_id: contract_id,
    )
  end
end
