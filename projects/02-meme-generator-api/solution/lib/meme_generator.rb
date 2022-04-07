require "sinatra/base"
require "json"

class MemeGenerator < Sinatra::Application
  post "/memes" do
    body = request.body.read
    return [400, "No request message!"] if body.empty?
    
    body = JSON.parse(body)
    [307, JSON.dump(body)]
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
