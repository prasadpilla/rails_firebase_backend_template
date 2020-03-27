module IdentifierGenerators

  def generate_hex_identifier(n)
    loop do
      identifier = SecureRandom.hex(n)
      break identifier unless self.class.find_by(beneficiary_id: identifier).present?
    end
  end
end