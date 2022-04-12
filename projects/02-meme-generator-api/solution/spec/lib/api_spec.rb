require "./lib/api"
require "rspec"

RSpec.describe API do
  include Rack::Test::Methods

  def app
    described_class
  end

  describe "POST /generate" do
    subject(:test_post) { post '/generate', body }

    context "with empty request body" do
      let(:body) { "" }

      it "responds with bad request" do
        test_post

        expect(last_response.status).to eq 400
      end
    end

    context "with valid request body" do
      let(:body) do
        {
          meme: {
            uri: "https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg",
            text: "Hi mom!"
          }
        }.to_json
      end

      it "responds with temporary redirect" do
        test_post

        expect(last_response.status).to eq 303
      end
    end

    context "with invalid request body, uri is wrong spelled" do
      let(:body) do
        {
          meme: {
            ur: "https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg",
            text: "Hi mom!"
          }
        }.to_json
      end

      it "responds with bad request" do
        test_post

        expect(last_response.status).to eq 400
      end
    end

    context "with invalid url in body" do
      let(:body) do
        {
          meme: {
            uri: "invalid_url",
            text: "Hi mom!"
          }
        }.to_json
      end

      it "responds with bad request" do
        test_post

        expect(last_response.status).to eq 400
      end
    end
  end

  describe "GET /meme/:file" do
    context "with precent POST on /generate" do
      let(:body) do
        {
          meme: {
            uri: "https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg",
            text: "Hi mom!"
          }
        }.to_json
      end
      let(:file_name) { "test.original.jpg" }

      before :each do
        post("/generate", body)
      end

      it "responds with ok" do
        get "/meme/#{file_name}"

        expect(last_response.status).to eq 200
      end
    end

    context "with not existing/invalid file" do
      let(:file_name) { "invalid.jpg" }

      before :each do
        FileUtils.rm_rf("./tmp")
      end

      it "responds with not found" do
        get "/meme/#{file_name}"

        expect(last_response.status).to eq 404
      end
    end
  end
end
