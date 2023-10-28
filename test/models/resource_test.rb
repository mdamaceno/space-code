require "test_helper"

class ResourceTest < ActiveSupport::TestCase
  setup do
    @valid_attributes = {
      name: "minerals",
      contract_id: contracts(:water_and_food_to_coruscant).id,
      weight: 100
    }
  end

  test "name is required" do
    resource = Resource.new(@valid_attributes.tap { |a| a[:name] = nil })
    assert_attribute_contains_error resource, :name, :blank
  end

  test "name should be one of the allowed values" do
    resource = Resource.new(@valid_attributes.tap { |a| a[:name] = "invalid" })
    assert_attribute_contains_error resource, :name, :inclusion
  end

  test "contract is required" do
    resource = Resource.new(@valid_attributes.tap { |a| a[:contract_id] = nil })
    assert_attribute_contains_error resource, :contract, :blank
  end

  test "weight is required" do
    resource = Resource.new(@valid_attributes.tap { |a| a[:weight] = nil })
    assert_attribute_contains_error resource, :weight, :blank
  end

  test "weight should be greater than or equal to 0" do
    resource = Resource.new(@valid_attributes.tap { |a| a[:weight] = -1 })
    assert_attribute_contains_error resource, :weight, :greater_than_or_equal_to
  end
end
