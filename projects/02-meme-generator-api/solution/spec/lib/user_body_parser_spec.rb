require "./lib/user_body_parser"
require "json"

RSpec.describe UserBodyParser do
  subject(:user_body_parser) { described_class }

  describe ".parse" do
    subject(:parse) { user_body_parser.parse(body) }

    context "with valid body" do
      let(:body) do
        {
          user: {
            username: "username",
            password: "password"
          }
        }.to_json
      end

      it "returns a hash with valid user information" do
        result = parse

        expect(result.class).to be Hash
        expect(result["user"]["username"]).to eq "username"
        expect(result["user"]["password"]).to eq "password"
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
