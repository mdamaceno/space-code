require "test_helper"

class RouteTest < ActiveSupport::TestCase
  test "origin_planet_id is required" do
    planet = planets(:coruscant)
    route = Route.new(destination_planet_id: planet.id)
    assert_attribute_contains_error route, :origin_planet_id, :blank
  end

  test "destination_planet_id is required" do
    planet = planets(:coruscant)
    route = Route.new(origin_planet_id: planet.id)
    assert_attribute_contains_error route, :destination_planet_id, :blank
  end

  test "origin_planet_id and destination_planet_id should not be equal" do
    planet = planets(:coruscant)
    route = Route.new(origin_planet_id: planet.id, destination_planet_id: planet.id)
    assert_attribute_contains_error route, :destination_planet_id, :equal_to
  end

  test "fuel_required should not be negative" do
    route = Route.new(fuel_cost: -1)
    assert_attribute_contains_error route, :fuel_cost, :greater_than_or_equal_to
  end
end
