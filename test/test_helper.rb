ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def assert_attribute_contains_error(object, attribute, error, message = nil)
      object.valid?
      errors = object.errors.select { |a| a.attribute == attribute }.map(&:type)
      assert_includes errors, error, message
    end
  end
end
