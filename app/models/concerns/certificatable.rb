module Certificatable
  extend ActiveSupport::Concern

  included do
    validates :certification, presence: true, uniqueness: true, length: { is: 7 }
    validate :validate_check_digit

    normalizes :certification, with: -> (certification) { certification&.gsub(/[^0-9]/, "") }

    def self.generate_valid_certification(num)
      digits = num.to_s[0..5].chars.map(&:to_i)

      sum = digits.reverse.each_with_index do |digit, index|
        digit * (index + 2)
      end.sum

      remainder = sum % 11
      remainder = 0 if remainder == 10

      "#{num}#{remainder}"
    end

    private

    def validate_check_digit
      return unless certification.present?

      digits = certification.to_s[0..5]

      valid_certification = self.class.generate_valid_certification(digits)

      errors.add(:certification, :invalid) if certification != valid_certification
    end
  end
end
