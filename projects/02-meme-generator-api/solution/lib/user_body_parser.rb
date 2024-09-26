require "json"
require "./lib/errors/user_body_error"

class UserBodyParser
  def self.parse(body)
    JSON.parse(body)

  rescue JSON::ParserError
    raise UserBodyError.new("Invalid body JSON syntax!")
  end
end
