require "sinatra/base"
require "json"
require "./lib/image_downloader"
require "./lib/memefier"

class MemeGeneratorAPI < Sinatra::Application
  TMP_PATH = "./tmp"
  IMAGE_PATH = TMP_PATH + "/original.jpeg"
  MEME_PATH = TMP_PATH + "/meme.jpeg"

  post "/generate" do
    body = request.body.read
    return [400, "No request message!"] if body.empty?
    
    body = JSON.parse(body)
    Dir.mkdir(TMP_PATH) unless Dir.exists?(TMP_PATH)
    ImageDownloader.download(body["meme"]["uri"], IMAGE_PATH)
    Memefier.memefy(IMAGE_PATH, MEME_PATH, body["meme"]["text"])

    redirect "/meme", 307
  rescue JSON::ParserError
    [400, "Invalid request syntax!"]
  rescue
    [500, "An unknown internal error occured!"]
  end

  post "/meme" do
    send_file(MEME_PATH)
  end

  class << self
    def run
      run!
    end
  end
end
