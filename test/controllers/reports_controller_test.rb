require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get total_weight_by_each_planet" do
    get reports_total_weight_by_each_planet_url
    assert_response :success
  end
end
