require "./meme_generator"
require "rspec"
require "rack"
require "rack/test"

RSpec.describe "meme_generator" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context "with application running" do
    it "responds with success status" do
      post "/memes"

      expect(last_response.status).to eq 200
    end
  end
end
