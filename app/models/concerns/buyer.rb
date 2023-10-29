module Buyer
  def buy_fuel(units = 1)
    amount = units * Seller::FUEL_UNIT_PRICE
    transaction = Transaction.new(
      certification: certification,
      kind: 'credit',
      amount: amount,
      description: "#{name} bought fuel: +₭#{amount}",
    )

    transaction.save!
    transaction
  end
end
