require "sinatra/base"
require "json"
require "pry"
require "down"
require "./lib/memefier"
require "./lib/meme_body_parser"
require "./lib/errors/meme_body_error"

class API < Sinatra::Application
  TMP_PATH = "./tmp/"

  post "/generate" do
    body = MemeBodyParser.parse(request.body.read)
    create_tmp_directory
    image_path = TMP_PATH + body.file_name
    Down.download(body.uri, destination: image_path)
    Memefier.memefy(image_path, body.text)

    redirect "/meme/#{body.file_name}", 303

  rescue Down::Error, URI::Error
    [400, "Invalid url in request body!"]
  rescue MemeBodyError => e
    [400, "#{e}"]
  rescue JSON::ParserError
    [400, "Invalid request body syntax!"]
  rescue
    [500, "An unknown internal error occured!"]
  end

  get "/meme/:file" do
    send_file(TMP_PATH + params[:file])
  end

  class << self
    def run
      run!
    end
  end

  private

  def create_tmp_directory
    Dir.mkdir(TMP_PATH) unless Dir.exists?(TMP_PATH)
  end
end
