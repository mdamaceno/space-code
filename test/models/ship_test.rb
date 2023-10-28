require "test_helper"

class ShipTest < ActiveSupport::TestCase
  setup do
    @valid_attributes = {
      name: "Millennium Falcon",
      pilot_id: pilots(:hans_solo).id,
      fuel_capacity: 100,
      fuel_level: 50,
      weight_capacity: 100
    }
  end

  test "name is required" do
    ship = Ship.new(@valid_attributes.tap { |a| a[:name] = nil })
    assert_attribute_contains_error ship, :name, :blank
  end

  test "name should be more than 3 characters" do
    ship = Ship.new(@valid_attributes.tap { |a| a[:name] = "ab" })
    assert_attribute_contains_error ship, :name, :too_short
  end

  test "name should be less than 150 characters" do
    ship = Ship.new(@valid_attributes.tap { |a| a[:name] = "a" * 151 })
    assert_attribute_contains_error ship, :name, :too_long
  end

  test "pilot is required" do
    ship = Ship.new(@valid_attributes.tap { |a| a[:pilot_id] = nil })
    assert_attribute_contains_error ship, :pilot, :blank
  end

  test "fuel_capacity is required" do
    ship = Ship.new(@valid_attributes.tap { |a| a[:fuel_capacity] = nil })
    assert_attribute_contains_error ship, :fuel_capacity, :blank
  end

  test "fuel_capacity should be greater than or equal to 0" do
    ship = Ship.new(@valid_attributes.tap { |a| a[:fuel_capacity] = -1 })
    assert_attribute_contains_error ship, :fuel_capacity, :greater_than_or_equal_to
  end

  test "fuel_level is required" do
    ship = Ship.new(@valid_attributes.tap { |a| a[:fuel_level] = nil })
    assert_attribute_contains_error ship, :fuel_level, :blank
  end

  test "fuel_level should be greater than or equal to 0" do
    ship = Ship.new(@valid_attributes.tap { |a| a[:fuel_level] = -1 })
    assert_attribute_contains_error ship, :fuel_level, :greater_than_or_equal_to
  end

  test "fuel_level should be less than or equal to fuel_capacity" do
    ship = Ship.new(@valid_attributes.tap { |a| a[:fuel_level] = 101 })
    assert_attribute_contains_error ship, :fuel_level, :less_than_or_equal_to
  end

  test "weight_capacity is required" do
    ship = Ship.new(@valid_attributes.tap { |a| a[:weight_capacity] = nil })
    assert_attribute_contains_error ship, :weight_capacity, :blank
  end
end
