require "sinatra/base"
require "json"
require "./lib/image_downloader"

class MemeGenerator < Sinatra::Application
  IMAGE_PATH = "./tmp/original.jpeg"

  post "/memes" do
    body = request.body.read
    return [400, "No request message!"] if body.empty?
    
    body = JSON.parse(body)
    ImageDownloader.download(body["meme"]["uri"], IMAGE_PATH)

    redirect "/meme", 307
  rescue JSON::ParserError
    [400, "Invalid request syntax!"]
  rescue
    [500, "An unknown internal error occured!"]
  end

  class << self
    def run
      run!
    end
  end
end
