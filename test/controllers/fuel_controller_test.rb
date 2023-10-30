require "test_helper"

class FuelControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_fuel_attributes = {
      units: 2,
      pilot_id: pilots(:hans_solo).id,
    }
  end

  test "should add fuel to the pilot's ship and create a credit transaction" do
    assert_difference('Transaction.count') do
      assert_difference('Ship.first.fuel_level', @valid_fuel_attributes[:units]) do
        post fuel_url, params: { fuel: @valid_fuel_attributes }
      end
    end

    assert_response :no_content
  end
end
