require "test_helper"

class ContractTest < ActiveSupport::TestCase
  setup do
    @valid_attributes = {
      description: "Minerals to Naboo",
      origin_planet_id: planets(:coruscant).id,
      destination_planet_id: planets(:naboo).id,
      ship_id: ships(:millennium_falcon).id,
      completed_at: nil,
      value: 30,
    }
  end

  test "description is required" do
    contract = Contract.new(@valid_attributes.tap { |a| a[:description] = nil })
    assert_attribute_contains_error contract, :description, :blank
  end

  test "description should be less than or equal to 255 characters" do
    contract = Contract.new(@valid_attributes.tap { |a| a[:description] = "a" * 256 })
    assert_attribute_contains_error contract, :description, :too_long
  end

  test "origin_planet is required" do
    contract = Contract.new(@valid_attributes.tap { |a| a[:origin_planet_id] = nil })
    assert_attribute_contains_error contract, :origin_planet_id, :blank
  end

  test "destination_planet is required" do
    contract = Contract.new(@valid_attributes.tap { |a| a[:destination_planet_id] = nil })
    assert_attribute_contains_error contract, :destination_planet_id, :blank
  end

  test "ship is optional" do
    contract = Contract.new(@valid_attributes.tap { |a| a[:ship_id] = nil })
    assert contract.valid?
  end

  test "completed_at is optional" do
    contract = Contract.new(@valid_attributes.tap { |a| a[:completed_at] = nil })
    assert contract.valid?
  end

  test "completed_at should be greater than or equal to time now" do
    contract = Contract.new(@valid_attributes.tap { |a| a[:completed_at] = Time.zone.now - 1.days })
    assert_attribute_contains_error contract, :completed_at, :greater_than_or_equal_to
  end

  test "value is required" do
    contract = Contract.new(@valid_attributes.tap { |a| a[:value] = nil })
    assert_attribute_contains_error contract, :value, :blank
  end

  test "value should be greater than or equal to 0" do
    contract = Contract.new(@valid_attributes.tap { |a| a[:value] = 0 })
    assert_attribute_contains_error contract, :value, :greater_than
  end

  test "complete! sets completed_at and creates a debit transaction" do
    contract = contracts(:water_and_food_to_coruscant)
    contract.complete!
    transaction = Transaction.order(created_at: :desc).first
    assert_not_nil contract.completed_at
    assert_equal contract.value, transaction.amount
    assert_equal contract.ship.pilot.certification, transaction.certification
    assert_equal contract.id, transaction.contract_id
    assert_equal "Contract #{contract.id} paid: -₭#{contract.value}", transaction.description
  end

  test "complete! raises an error if contract is already completed" do
    contract = contracts(:water_and_food_to_coruscant)
    contract.complete!

    assert_raises(CustomErrors::ContractAlreadyCompletedError) { contract.complete! }
  end

  test "complete! raises an error if ship_id is not set" do
    contract = contracts(:without_ship_id)
    assert_raises(CustomErrors::ContractWithoutShipError) { contract.complete! }
  end

  test "payload should return resources" do
    contract = contracts(:water_and_food_to_coruscant)
    assert contract.payload.size.positive?
  end

  test "scope incomplete should return contracts with completed_at nil" do
    assert Contract.incomplete.all? { |c| c.completed_at.nil? }
  end
end
