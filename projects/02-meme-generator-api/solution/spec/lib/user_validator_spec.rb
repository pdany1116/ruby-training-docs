require "./lib/user_validator"
require "json"

RSpec.describe UserValidator do
  subject(:user_validator) { described_class }

  describe ".validate" do
    subject(:validate) { user_validator.validate(body) }

    context "with valid body" do
      let(:body) do
        {
          "user" => {
            "username" => "username",
            "password" => "password"
          }
        }
      end

      it "does not raise any error" do
        expect{ validate }.not_to raise_error()
      end
    end

    context "with body missing user key" do
      let(:body) do
        {
          "username" => "username",
          "password" => "password"
        }
      end

      it "raises UserBodyError with user key missing message" do
        expect{ "#{validate}" }.to raise_error("'user' not found in body!")
      end
    end

    context "with body missing password key" do
      let(:body) do
        {
          "user" => {
            "username" => "username"
          }
        }
      end

      it "raises UserBodyError with password missing message" do
        expect{ "#{validate}" }.to raise_error("'user.password' not found in body!")
      end
    end

    context "with body missing username key" do
      let(:body) do
        {
          "user" => {
            "password" => "password"
          }
        }
      end

      it "raises UserBodyError with username key missing message" do
        expect{ "#{validate}" }.to raise_error("'user.username' not found in body!")
      end
    end

    context "with blank username" do
      let(:body) do
        {
          "user" => {
            "username" => "",
            "password" => "password"
          }
        }
      end
      let(:errors) do
        {
          "errors": [
            {
              "message": "Username is blank!"
            }
          ]
        }.to_json
      end

      it "raises UserInputError with errors array and username blank message" do
        expect{ validate }.to raise_error(UserInputError)
        expect{ "#{validate}" }.to raise_error(errors)
      end
    end

    context "with blank password" do
      let(:body) do
        {
          "user" => {
            "username" => "username",
            "password" => ""
          }
        }
      end
      let(:errors) do
        {
          "errors": [
            {
              "message": "Password is blank!"
            }
          ]
        }.to_json
      end

      it "raises UserInputError with errors array and username blank message" do
        expect{ validate }.to raise_error(UserInputError)
        expect{ "#{validate}" }.to raise_error(errors)
      end
    end

    context "with blank password and blank username" do
      let(:body) do
        {
          "user" => {
            "username" => "",
            "password" => ""
          }
        }
      end
      let(:errors) do
        {
          "errors": [
            {
              "message": "Username is blank!"
            },
            {
              "message": "Password is blank!"
            }
          ]
        }.to_json
      end

      it "raises UserInputError with errors array and username blank message" do
        expect{ validate }.to raise_error(UserInputError)
        expect{ "#{validate}" }.to raise_error(errors)
      end
    end
  end
end
