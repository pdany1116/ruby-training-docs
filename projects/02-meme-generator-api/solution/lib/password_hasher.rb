require "bcrypt"

class PasswordHasher 
  def self.create(plain_text)
    BCrypt::Password.create(plain_text).to_s
  end

  def self.valid?(hash, plain_text)
    BCrypt::Password.new(hash) == plain_text
  end
end
