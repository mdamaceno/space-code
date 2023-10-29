require "test_helper"

class PilotTest < ActiveSupport::TestCase
  setup do
    @valid_attributes = {
      name: 'Bo Katan',
      age: 18,
      certification: '7635290',
      location: nil,
    }
  end

  test "name is required" do
    pilot = Pilot.new(@valid_attributes.merge(name: nil))
    assert_attribute_contains_error pilot, :name, :blank
  end

  test "name should not be less than 3 characters" do
    pilot = Pilot.new(@valid_attributes.merge(name: "ab"))
    assert_attribute_contains_error pilot, :name, :too_short
  end

  test "name should not be more than 150 characters" do
    pilot = Pilot.new(@valid_attributes.merge(name: "a" * 151))
    assert_attribute_contains_error pilot, :name, :too_long
  end

  test "age is required" do
    pilot = Pilot.new(@valid_attributes.merge(age: nil))
    assert_attribute_contains_error pilot, :age, :blank
  end

  test "age should not be less than 18" do
    pilot = Pilot.new(@valid_attributes.merge(age: 17))
    assert_attribute_contains_error pilot, :age, :greater_than_or_equal_to
  end

  test "certification is required" do
    pilot = Pilot.new(@valid_attributes.merge(certification: nil))
    assert_attribute_contains_error pilot, :certification, :blank
  end

  test "certification should contain 7 characters" do
    pilot = Pilot.new(@valid_attributes.merge(certification: "123456"))
    assert_attribute_contains_error pilot, :certification, :wrong_length
  end

  test "certification should be unique" do
    pilot = Pilot.new(@valid_attributes.merge(certification: pilots(:hans_solo).certification))
    assert_attribute_contains_error pilot, :certification, :taken
  end

  test "certification should be valid if check digit (last) is incorrect" do
    pilot = Pilot.new(@valid_attributes.merge(certification: "1234567"))
    assert_attribute_contains_error pilot, :certification, :invalid
  end

  test "certification should be valid if check digit (last) is correct" do
    ["987655-7", "632988-3", "774199-4"].each do |certification|
      pilot = Pilot.new(@valid_attributes.merge(certification: certification))
      assert pilot.valid?
    end
  end

  test "location should be optional" do
    pilot = Pilot.new(@valid_attributes.merge(location: nil))
    assert pilot.valid?
  end

  test "generate_valid_certification should return a valid certification" do
    certification = Pilot.generate_valid_certification("445566")
    assert certification.length == 7
  end

  test "buy_fuel should create a credit transaction" do
    pilot = pilots(:hans_solo)
    units = 2
    amount = units * Planet::FUEL_UNIT_PRICE
    transaction = pilot.buy_fuel(units)
    assert_equal 'credit', transaction.kind
    assert_equal pilot.certification, transaction.certification
    assert_equal amount, transaction.amount
    assert_equal "#{pilot.name} bought fuel: +₭#{amount}", transaction.description
  end

  test "buy_fuel should raise an error if the pilot does not have enough credits" do
    pilot = pilots(:hans_solo)
    units = 100
    assert_raises CustomErrors::NotSufficientCreditsError do
      pilot.buy_fuel(units)
    end
  end

  test "credits should return the sum of all transactions with the pilot certification" do
    pilot = pilots(:hans_solo)
    units = 2
    initial_amount = [
      Transaction.debits.for_certification(pilot.certification).sum(:amount),
      Transaction.credits.for_certification(pilot.certification).sum(:amount) * -1,
    ].sum
    pilot.buy_fuel(units)
    assert_equal initial_amount - (units * Planet::FUEL_UNIT_PRICE), pilot.credits
  end
end
