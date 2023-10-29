require "test_helper"

class TravelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pilot = pilots(:hans_solo)
    @planet = planets(:naboo)
    @valid_travel = {
      pilot_id: @pilot.id,
      planet_id: @planet.id,
    }
  end

  test "should update the pilot's location" do
    post travels_url, params: { travel: @valid_travel }

    assert @pilot.reload.location == @planet
    assert_response :no_content

    post travels_url, params: { travel: @valid_travel.merge(planet_id: planets(:bespin).id) }

    assert @pilot.reload.location == planets(:bespin)
    assert_response :no_content
  end
end
