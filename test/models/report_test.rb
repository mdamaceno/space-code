require "test_helper"

class ReportTest < ActiveSupport::TestCase
  test "should return the total weight in tons of each resource sent and received by each planet" do
    origin_planet = FactoryBot.create(:planet, name: "Tatooine")
    destination_planet = FactoryBot.create(:planet, name: "Alderaan")
    pilot = FactoryBot.create(:pilot, name: "Luke Skywalker")
    ship = FactoryBot.create(:ship, name: "X-Wing", pilot: pilot)
    contracts = FactoryBot.create_list(:contract, 5, origin_planet_id: origin_planet.id, destination_planet_id: destination_planet.id, ship: ship, completed_at: Time.zone.now)
    contracts.each do |contract|
      FactoryBot.create_list(:resource, 3, name: 'water', weight: 1, contract: contract)
      FactoryBot.create_list(:resource, 2, name: 'food', weight: 2, contract: contract)
      FactoryBot.create_list(:resource, 1, name: 'minerals', weight: 3, contract: contract)
    end

    tatooine_result = {
      "tatooine" => {
        "sent" => {
          "water" => 15,
          "food" => 20,
          "minerals" => 15,
        },
        "received" => {
          "water" => 0,
          "food" => 0,
          "minerals" => 0,
        },
      },
    }

    alderaan_result = {
      "alderaan" => {
        "sent" => {
          "water" => 0,
          "food" => 0,
          "minerals" => 0,
        },
        "received" => {
          "water" => 15,
          "food" => 20,
          "minerals" => 15,
        },
      },
    }

    report = Report.new
    assert_includes report.total_weight_by_each_planet, tatooine_result
    assert_includes report.total_weight_by_each_planet, alderaan_result
  end
end
