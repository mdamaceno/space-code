require "test_helper"

class PilotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_pilot = {
      name: 'Bo Katan',
      age: 30,
      ship: {
        name: 'Gauntlet Fighter',
        fuel_capacity: 100,
        fuel_level: 100,
        weight_capacity: 100,
      }
    }
  end

  test "should create pilot along with the ship" do
    assert_difference('Pilot.count') do
      assert_difference('Ship.count') do
        post pilots_url, params: { pilot: @valid_pilot }
      end
    end

    assert_response :created
  end

  test "should not create pilot if ship is invalid" do
    @valid_pilot[:ship][:fuel_capacity] = 0

    assert_no_difference('Pilot.count') do
      assert_no_difference('Ship.count') do
        post pilots_url, params: { pilot: @valid_pilot }
      end
    end

    assert_response :unprocessable_entity
  end
end
