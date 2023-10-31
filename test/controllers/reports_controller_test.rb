require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get total_weight_by_each_planet" do
    get reports_total_weight_by_each_planet_url
    assert_response :success
  end

  test "should get percentage_resource_by_each_pilot" do
    get reports_percentage_resource_by_each_pilot_url
    assert_response :success
  end

  test "should get transaction_ledger" do
    get reports_transaction_ledger_url
    assert_response :success
  end
end
