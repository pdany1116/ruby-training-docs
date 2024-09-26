require "securerandom"

class TokenGenerator
  def self.generate
    SecureRandom.hex(16)
  end
end
