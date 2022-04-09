require "json"
require "./lib/meme_body"

class BodyParser
  def self.parse(body)
    json_body = JSON.parse(body)
    MemeBody.new(json_body["meme"]["uri"], json_body["meme"]["text"])
  rescue
    raise JSON::ParserError
  end
end
