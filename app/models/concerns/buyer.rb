module Buyer
  def buy_fuel(units = 1)
    raise CustomErrors::NotSufficientCreditsError if credits < units * Seller::FUEL_UNIT_PRICE

    amount = units * Seller::FUEL_UNIT_PRICE
    transaction = Transaction.new(
      certification: certification,
      kind: 'credit',
      amount: amount,
      description: "#{name} bought fuel: +₭#{amount}",
    )

    ActiveRecord::Base.transaction do
      self.ship.fuel_level += units
      self.ship.save!

      transaction.save!
      transaction
    end
  end
end
