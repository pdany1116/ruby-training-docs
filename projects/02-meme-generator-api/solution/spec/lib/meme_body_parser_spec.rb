require "./lib/meme_body_parser"
require "json"

RSpec.describe MemeBodyParser do
  subject(:meme_body_parser) { described_class }

  describe ".parse" do
    subject(:parse) { meme_body_parser.parse(body) }

    context "with valid body." do
      let(:body) do
        {
          meme: {
            uri: "uri.example.com",
            text: "Hi mom!"
          }
        }.to_json
      end

      it "returns a MemeBody object with valid text and uri" do
        result = parse

        expect(result.class).to be MemeBody
        expect(result.uri).to eq "uri.example.com"
        expect(result.text).to eq "Hi mom!"
      end
    end

    context "with body missing meme key" do
      let(:body) do
        {
          uri: "uri.example.com",
          text: "Hi mom!"
        }.to_json
      end

      it "raises MemeBodyError with meme key missing message" do
        expect{ "#{parse}" }.to raise_error("'meme' not found in body!")
      end
    end

    context "with body missing uri key" do
      let(:body) do
        {
          meme: {
            text: "Hi mom!"
          }
        }.to_json
      end

      it "raises MemeBodyError with uri key missing message" do
        expect{ "#{parse}" }.to raise_error("'meme.uri' not found in body!")
      end
    end

    context "with body missing text key" do
      let(:body) do
        {
          meme: {
            uri: "uri.example.com"
          }
        }.to_json
      end

      it "raises MemeBodyError with text key missing message" do
        expect{ "#{parse}" }.to raise_error("'meme.text' not found in body!")
      end
    end

    context "with invalid body json syntax, missing starting brace" do
      let(:body) { 'meme: {uri: "uri.example.com",text: "Hi mom!"}}' }

      it "raises MemeBodyError with invalid json syntax" do
        expect{ "#{parse}" }.to raise_error("Invalid body JSON syntax!")
      end
    end

    context "with empty json body" do
      let(:body) { "" }

      it "raises MemeBodyError with invalid json syntax" do
        expect{ "#{parse}" }.to raise_error("Invalid body JSON syntax!")
      end
    end
  end
end
