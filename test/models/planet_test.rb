require "test_helper"

class PlanetTest < ActiveSupport::TestCase
  test "name is required" do
    planet = Planet.new
    assert_attribute_contains_error planet, :name, :blank
  end

  test "name is unique" do
    name = planets(:coruscant).name
    planet = Planet.new(name: name)
    assert_attribute_contains_error planet, :name, :taken
  end

  test "name should not be less than 3 characters" do
    planet = Planet.new(name: "ab")
    assert_attribute_contains_error planet, :name, :too_short
  end

  test "name should not be more than 150 characters" do
    planet = Planet.new(name: "a" * 151)
    assert_attribute_contains_error planet, :name, :too_long
  end
end
