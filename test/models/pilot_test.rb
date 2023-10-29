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

  test "travel_to! should keep fuel_level of the ship the same and change pilot location if location is not set yet" do
    pilot = pilots(:hans_solo)
    ship = pilot.ship
    destination_planet = planets(:coruscant)
    fuel_level = ship.fuel_level
    location = pilot.location
    pilot.travel_to!(destination_planet)

    assert_equal fuel_level, ship.reload.fuel_level
    assert_equal destination_planet, pilot.reload.location
  end

  test "travel_to! should decrease fuel_level of the ship and change pilot location if location is set" do
    pilot = pilots(:din_djarin)
    ship = pilot.ship
    destination_planet = planets(:bespin)
    fuel_level = ship.fuel_level
    fuel_cost = Route.fuel_cost(pilot.location, destination_planet)
    pilot.travel_to!(destination_planet)

    assert_equal destination_planet, pilot.reload.location
    assert_equal fuel_level - fuel_cost, ship.reload.fuel_level
  end

  test "travel_to! should raise an error if route is blocked" do
    pilot = pilots(:boba_fett)
    ship = pilot.ship
    destination_planet = planets(:bespin)
    assert_raises CustomErrors::RouteBlockedError do
      pilot.travel_to!(destination_planet)
    end
  end

  test "accept_contract! should set ship id to the contract" do
    pilot = pilots(:din_djarin)
    contract = contracts(:without_ship_id)
    pilot.accept_contract!(contract)
    assert_equal pilot.ship.id, contract.reload.ship_id
  end

  test "accept_contract! should raise an error if ship does not have fuel" do
    pilot = pilots(:pilot_no_fuel)
    contract = contracts(:without_ship_id)
    assert_raises CustomErrors::NoFuelError do
      pilot.accept_contract!(contract)
    end
  end

  test "accept_contract! should raise an error if ship does not have enough cargo capacity" do
    pilot = pilots(:pilot_no_cargo_capacity)
    contract = contracts(:water_and_food_to_coruscant)
    assert_raises CustomErrors::NoCargoCapacityError do
      pilot.accept_contract!(contract)
    end
  end
end
