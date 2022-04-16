require "sinatra/base"
require "json"
require "pry"
require "./lib/db/db"
require "./lib/memefier"
require "./lib/meme_body_parser"
require "./lib/user_body_parser"
require "./lib/image_downloader"
require "./lib/password_hasher"
require "./lib/token_generator"
require "./lib/validator/user_validator"

class API < Sinatra::Application
  post "/signup" do
    params = UserBodyParser.parse(request.body.read)
    UserValidator.validate(params)
    user = create_user(params)
    token = TokenGenerator.generate
    user_id = db.insert_user(user)
    db.insert_token(Token.new(user_id, token))

    [201, { "user": { "token": token } }.to_json]

  rescue UserBodyError => e
    [409, "#{e}"]
  end

  post "/login" do
    500
  end

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

  private

  def db
    DB.create
  end

  def create_user(params)
    User.new(params["user"]["username"], PasswordHasher.create(params["user"]["password"]))
  end
end
