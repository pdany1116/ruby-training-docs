require "json"
require "./lib/meme_body"
require "./lib/errors/meme_body_error"

class MemeBodyParser
  def self.parse(body)
    json_body = JSON.parse(body)

    raise MemeBodyError.new("'meme' not found in body!") unless json_body["meme"]
    raise MemeBodyError.new("'meme.uri' not found in body!") unless json_body["meme"]["uri"]
    raise MemeBodyError.new("'meme.text' not found in body!") unless json_body["meme"]["text"]

    MemeBody.new(json_body["meme"]["uri"], json_body["meme"]["text"])
  end
end
