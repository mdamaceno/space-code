require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  setup do
    @valid_attributes = {
      amount: 100,
      description: 'Test transaction',
      certification: '7635290',
      kind: 'credit',
      contract_id: nil,
    }
  end

  test "amount should not be negative" do
    transaction = Transaction.new(@valid_attributes.merge(amount: -1))
    assert_attribute_contains_error transaction, :amount, :greater_than_or_equal_to
  end

  test "amount should be present" do
    transaction = Transaction.new(@valid_attributes.merge(amount: nil))
    assert_attribute_contains_error transaction, :amount, :blank
  end

  test "kind should be credit or debit" do
    transaction = Transaction.new(@valid_attributes.merge(kind: 'invalid'))
    assert_attribute_contains_error transaction, :kind, :inclusion
  end

  test "kind should be present" do
    transaction = Transaction.new(@valid_attributes.merge(kind: nil))
    assert_attribute_contains_error transaction, :kind, :blank
  end

  test "certification should be present" do
    transaction = Transaction.new(@valid_attributes.merge(certification: nil))
    assert_attribute_contains_error transaction, :certification, :blank
  end

  test "contract should be optional" do
    transaction = Transaction.new(@valid_attributes.merge(contract_id: nil))
    assert transaction.valid?
  end
end
