require "./lib/api"
require "./lib/db/db"
require "rspec"

RSpec.describe API do
  include Rack::Test::Methods

  def app
    described_class
  end

  before :all do
    DB.create.clear_all
  end

  describe "POST /generate" do
    subject(:test_post) { post '/generate', body }

    context "with empty request body" do
      let(:body) { "" }

      it "responds with bad request" do
        test_post

        expect(last_response.status).to eq 400
        expect(last_response.body).to eq "Invalid body JSON syntax!"
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
        expect(last_response.location).to eq "http://example.org/meme/test.original.jpg"
      end
    end

    context "with invalid request body, non json format" do
      let(:body) { "{ds234]" }

      it "responds with bad request" do
        test_post

        expect(last_response.status).to eq 400
        expect(last_response.body).to eq "Invalid body JSON syntax!"
      end
    end

    context "with invalid request body, meme is missing" do
      let(:body) do
        {
          uri: "https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg",
          text: "Hi mom!"
        }.to_json
      end

      it "responds with bad request" do
        test_post

        expect(last_response.status).to eq 400
        expect(last_response.body).to eq "'meme' not found in body!"
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
        expect(last_response.body).to eq "'meme.uri' not found in body!"
      end
    end

    context "with invalid request body, text is missing" do
      let(:body) do
        {
          meme: {
            uri: "https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg"
          }
        }.to_json
      end

      it "responds with bad request" do
        test_post

        expect(last_response.status).to eq 400
        expect(last_response.body).to eq "'meme.text' not found in body!"
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
        expect(last_response.body).to eq "Invalid URI provided!"
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

  describe "POST /signup" do
    subject(:test_post) { post '/signup', body }

    context "with valid request body" do
      let(:body) do
        {
          user: {
            username: "user1",
            password: "password"
          }
        }.to_json
      end

      it "responds with created status and user token in response body" do
        test_post

        token = JSON.parse(last_response.body)["user"]["token"]

        expect(last_response.status).to eq 201
        expect(token.match?(/^[0-9a-hA-H]+$/)).to eq true
      end
    end

    context "with empty username" do
      let(:body) do
        {
          user: {
            username: "",
            password: "password"
          }
        }.to_json
      end

      let(:error) { { "message" => "Username is blank!" } }

      it "responds with bad request and username blank error message" do
        test_post

        errors = JSON.parse(last_response.body)["errors"]

        expect(last_response.status).to eq 400
        expect(errors[0]).to eq error
      end
    end

    context "with empty password" do
      let(:body) do
        {
          user: {
            username: "user2",
            password: ""
          }
        }.to_json
      end

      let(:error) { { "message" => "Password is blank!" } }

      it "responds with bad request and password blank error message" do
        test_post

        errors = JSON.parse(last_response.body)["errors"]

        expect(last_response.status).to eq 400
        expect(errors[0]).to eq error
      end
    end

    context "with valid request body, but username already exists" do
      let(:body) do
        {
          user: {
            username: "user3",
            password: "password"
          }
        }.to_json
      end

      before :each do
        post '/signup', body
      end

      it "responds with conflict" do
        test_post

        expect(last_response.status).to eq 409
      end
    end
  end

  describe "POST /login" do
    subject(:test_post) { post '/login', body }

    context "with valid request body and with user existing" do
      let(:body) do
        {
          user: {
            username: "user4",
            password: "password"
          }
        }.to_json
      end

      before :each do
        post '/signup', body
      end

      it "responds with ok and user token in response body" do
        test_post

        token = JSON.parse(last_response.body)["user"]["token"]

        expect(last_response.status).to eq 200
        expect(token.match?(/^[0-9a-hA-H]+$/)).to eq true
      end
    end

    context "with valid request body, but with not registered user" do
      let(:body) do
        {
          user: {
            username: "user5",
            password: "password"
          }
        }.to_json
      end

      it "responds with conflict" do
        test_post

        expect(last_response.status).to eq 409
      end
    end
  end
end
