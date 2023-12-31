require "test_helper"

class ContractsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_contract = {
      description: 'Minerals and food to Bespin',
      origin_planet_id: planets(:bespin).id,
      destination_planet_id: planets(:naboo).id,
      ship_id: nil,
      value: 30,
      payload: [
        {
          name: 'minerals',
          weight: 10,
        },
        {
          name: 'food',
          weight: 13,
        }
      ]
    }
  end

  test "should create contract" do
    assert_difference('Contract.count') do
      assert_difference('Resource.count', 2) do
        post contracts_url, params: { contract: @valid_contract }
      end
    end

    assert_response :created
  end

  test "should not create contract if payload is invalid" do
    @valid_contract[:payload][0][:weight] = -1

    assert_no_difference('Contract.count') do
      assert_no_difference('Resource.count') do
        post contracts_url, params: { contract: @valid_contract }
      end
    end

    assert_response :unprocessable_entity
  end

  test "should not create contract if contract is invalid" do
    @valid_contract[:value] = 0

    assert_no_difference('Contract.count') do
      assert_no_difference('Resource.count') do
        post contracts_url, params: { contract: @valid_contract }
      end
    end

    assert_response :unprocessable_entity
  end

  test "should retrive all open contracts" do
    get contracts_url
    parsed_response = JSON.parse(response.body)

    assert parsed_response['contracts'].all? { |c| c['completed_at'].nil? }
    assert parsed_response['contracts'].size > 0
    assert_response :success
  end

  test "should update ship_id when contract is accepted" do
    contract = contracts(:without_ship_id)
    pilot = pilots(:hans_solo)
    pilot.update!(planet_id: contract.origin_planet_id)
    assert contract.ship_id.nil?

    post accept_contract_url(contract), params: { contract: { pilot_id: pilot.id } }
    contract.reload

    assert contract.ship_id == pilot.ship.id
    assert_response :no_content
  end
end
