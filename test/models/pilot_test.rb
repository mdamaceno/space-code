require "test_helper"

class PilotTest < ActiveSupport::TestCase
  test "name is required" do
    pilot = Pilot.new
    assert_not pilot.valid?
    assert_attribute_contains_error pilot, :name, :blank
  end

  test "name should not be less than 3 characters" do
    pilot = Pilot.new(name: "ab")
    assert_attribute_contains_error pilot, :name, :too_short
  end

  test "name should not be more than 150 characters" do
    pilot = Pilot.new(name: "a" * 151)
    assert_attribute_contains_error pilot, :name, :too_long
  end

  test "age is required" do
    pilot = Pilot.new
    assert_not pilot.valid?
    assert_attribute_contains_error pilot, :age, :blank
  end

  test "age should not be less than 18" do
    pilot = Pilot.new(age: 17)
    assert_not pilot.valid?
    assert_attribute_contains_error pilot, :age, :greater_than_or_equal_to
  end

  test "certification is required" do
    pilot = Pilot.new
    assert_not pilot.valid?
    assert_attribute_contains_error pilot, :certification, :blank
  end

  test "certification should contain 7 characters" do
    pilot = Pilot.new(certification: "123456")
    assert_not pilot.valid?
    assert_attribute_contains_error pilot, :certification, :wrong_length
  end

  test "certification should be unique" do
    pilot = Pilot.new(certification: pilots(:hans_solo).certification)
    assert_not pilot.valid?
    assert_attribute_contains_error pilot, :certification, :taken
  end
end
