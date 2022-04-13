require "json"
require "./lib/user_body"
require "./lib/errors/user_body_error"

class UserBodyParser
  def self.parse(body)
    json_body = JSON.parse(body)

    raise UserBodyError.new("'user' not found in body!") unless json_body["user"]
    raise UserBodyError.new("'user.username' not found in body!") unless json_body["user"]["username"]
    raise UserBodyError.new("'user.password' not found in body!") unless json_body["user"]["password"]

    UserBody.new(json_body["user"]["username"], json_body["user"]["password"])

  rescue JSON::ParserError
    raise UserBodyError.new("Invalid body JSON syntax!")
  end
end
