class Pilot < ApplicationRecord
  include Certificatable
  include Buyer

  has_one :ship

  validates :name, presence: true, length: { minimum: 3, maximum: 150 }
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 18 }

  def credits
    [
      Transaction.debits.for_certification(self.certification).sum(:amount),
      Transaction.credits.for_certification(self.certification).sum(:amount) * -1,
    ].sum
  end
end
