require "securerandom"

class TokenGenerator
  def self.create
    SecureRandom.hex(16)
  end
end
