require "./lib/user_body_parser"
require "json"

RSpec.describe UserBodyParser do
  subject(:user_body_parser) { described_class }

  describe ".parse" do
    subject(:parse) { user_body_parser.parse(body) }

    context "with valid body." do
      let(:body) do
        {
          user: {
            username: "username",
            password: "password"
          }
        }.to_json
      end

      it "returns a UserBody object with valid username and password" do
        result = parse

        expect(result.class).to be UserBody
        expect(result.username).to eq "username"
        expect(result.password).to eq "password"
      end
    end

    context "with body missing user key" do
      let(:body) do
        {
          username: "username",
          password: "password"
        }.to_json
      end

      it "raises UserBodyError with user key missing message" do
        expect{ "#{parse}" }.to raise_error("'user' not found in body!")
      end
    end

    context "with body missing password key" do
      let(:body) do
        {
          user: {
            username: "username"
          }
        }.to_json
      end

      it "raises UserBodyError with password missing message" do
        expect{ "#{parse}" }.to raise_error("'user.password' not found in body!")
      end
    end

    context "with body missing username key" do
      let(:body) do
        {
          user: {
            password: "password"
          }
        }.to_json
      end

      it "raises UserBodyError with username key missing message" do
        expect{ "#{parse}" }.to raise_error("'user.username' not found in body!")
      end
    end

    context "with invalid body json syntax, missing starting brace" do
      let(:body) { 'user: {username: "username",password: "password"}}' }

      it "raises UserBodyError with invalid json syntax" do
        expect{ "#{parse}" }.to raise_error("Invalid body JSON syntax!")
      end
    end

    context "with empty json body" do
      let(:body) { "" }

      it "raises UserBodyError with invalid json syntax" do
        expect{ "#{parse}" }.to raise_error("Invalid body JSON syntax!")
      end
    end
  end
end
