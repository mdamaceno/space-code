class Pilot < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3, maximum: 150 }
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 18 }
  validates :certification, presence: true, uniqueness: true, length: { is: 7 }
  validate :validate_check_digit

  normalizes :certification, with: -> (certification) { certification&.gsub(/[^0-9]/, "") }

  private

  def validate_check_digit
    return unless certification.present?

    digits = certification.chars.map(&:to_i)
    check_digit = digits.pop

    sum = digits.reverse.each_with_index do |digit, index|
      digit * (index + 2)
    end.sum

    remainder = sum % 11
    remainder = 0 if remainder == 10

    errors.add(:certification, :invalid) if remainder != check_digit
  end
end
