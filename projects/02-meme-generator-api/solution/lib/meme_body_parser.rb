require "json"
require "./lib/meme_body"
require "./lib/errors/meme_body_error"

class MemeBodyParser
  def self.parse(body)
    json_body = JSON.parse(body)
    raise MemeBodyError("'meme' not found in body!") unless json_body["meme"]
    raise MemeBodyError("'meme.uri' not found in body!") unless json_body["meme"]["uri"]
    raise MemeBodyError("'meme.text' not found in body!") unless json_body["meme"]["text"]

    MemeBody.new(json_body["meme"]["uri"], json_body["meme"]["text"])
  rescue
    raise JSON::ParserError
  end
end
