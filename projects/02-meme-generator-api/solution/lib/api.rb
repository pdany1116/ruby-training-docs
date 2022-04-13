require "sinatra/base"
require "json"
require "pry"
require "./lib/memefier"
require "./lib/meme_body_parser"
require "./lib/image_downloader"

class API < Sinatra::Application
  post "/generate" do
    body = MemeBodyParser.parse(request.body.read)

    ImageDownloader.create.download(body.uri, body.file_name)
    Memefier.memefy(body.file_name, body.text)

    redirect "/meme/#{body.file_name}", 303

  rescue MemeBodyError, ImageDownloaderError => e
    [400, "#{e}"]
  end

  get "/meme/:file" do
    send_file("./tmp/" + params[:file])
  end

  class << self
    def run
      run!
    end
  end
end
