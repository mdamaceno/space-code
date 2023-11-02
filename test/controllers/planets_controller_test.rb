require "test_helper"

class PlanetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get planets_url
    parsed_response = JSON.parse(response.body)

    assert parsed_response['planets'].size > 0
    assert_response :success
  end
end
