require "./lib/meme_generator"
require "rspec"

RSpec.describe MemeGenerator do
  include Rack::Test::Methods

  def app
    described_class
  end

  describe "post" do
    subject(:test_post) { post(route, request) }

    context "with empty request body" do
      let(:route) { "/memes" }
      let(:request) { "" }

      it "responds with bad request" do
        test_post

        expect(last_response.status).to eq 400
      end
    end

    context "with valid request body" do
      let(:route) { "/memes" }
      let(:request) { "{\"test\": 123}" }

      it "responds with redirect" do
        test_post

        expect(last_response.status).to eq 307
      end
    end

    context "with empty invalid request body" do
      let(:route) { "/memes" }
      let(:request) { "{test : 123}" }

      it "responds with bad request" do
        test_post

        expect(last_response.status).to eq 400
      end
    end

    context "with invalid route" do
      let(:route) { "/invalid" }
      let(:request) { "{\"test\": 123}" }

      it "responds with not found" do
        test_post

        expect(last_response.status).to eq 404
      end
    end
  end
end
