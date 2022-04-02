require "spec_helper"
require "./lib/commands/search/option_parser_search_command"

RSpec.describe OptionParserSearchCommand do
  subject(:program) { described_class }

  describe ".parse" do
    subject(:parse) { program.parse(args) }

    context "with no option specified" do
      let(:args) { [] }
      it "returns empty array of options" do
        result = parse

        expect(result.size).to eq 0
        expect(result.class).to be Array
      end
    end

    context "with --license LICENSE option" do
      let(:args) { %w[--license LICENSE] }

      it "returns options array with one OptionLicense object" do
        result = parse
        
        expect(result.size).to eq 1
        expect(result.class).to be Array
        expect(result[0].class).to be OptionLicense
      end
    end

    context "with --most-downloads-first option" do
      let(:args) { %w[--most-downloads-first] }

      it "returns options array with one OptionMostDownloadsFirst object" do
        result = parse
        
        expect(result.size).to eq 1
        expect(result.class).to be Array
        expect(result[0].class).to be OptionMostDownloadsFirst
      end
    end

    context "with both options" do
      let(:args) { %w[--most-downloads-first --license LICENSE] }

      it "returns options array with one OptionMostDownloadsFirst and one OptionLicense" do
        result = parse
        
        expect(result.size).to eq 2
        expect(result.class).to be Array
        expect(result.any?(OptionMostDownloadsFirst)).to be true
        expect(result.any?(OptionLicense)).to be true
      end
    end

    context "with invalid option" do
      let(:args) { %w[--invalid-option] }

      it "raises ParserError::InvalidOption" do
        expect { parse }.to raise_error(OptionParser::InvalidOption)
      end
    end

    context "with multiple options (valid and invalid)" do
      let(:args) { %w[--most-downloads-first --license LICENSE --invalid-option] }

      it "raises ParserError::InvalidOption" do
        expect { parse }.to raise_error(OptionParser::InvalidOption)
      end
    end

    context "with multiple arguments for --license option", :skip do
      let(:args) { %w[--license MIT LICENSE] }

      it "raises ParserError::InvalidOption" do
        expect { parse }.to raise_error(OptionParser::InvalidOption)
      end
    end
  end
end
