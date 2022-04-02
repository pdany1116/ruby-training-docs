require "spec_helper"
require "./lib/program"
require "./lib/commands/results/command_error_result"
require "./lib/commands/results/show_command_result"
require "./lib/commands/results/search_command_result"

RSpec.describe Program do
  subject(:program) { described_class }

  describe ".execute" do
    subject(:execute) { program.execute(argv)}

    context "with non existing command name" do
      let(:argv) { ["non_existing_command"] }

      it "returns CommandErrorResult" do
        result = execute

        expect(result.class).to be CommandErrorResult
        expect(result.error_message).to eq "Invalid option non_existing_command!"
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with nil command name" do
      let(:argv) { [nil] }

      it "returns CommandErrorResult" do
        result = execute
        
        expect(result.class).to be CommandErrorResult
        expect(result.error_message).to eq "No command provided!"
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with empty command name" do
      let(:argv) { [""] }

      it "returns CommandErrorResult" do
        result = execute
        
        expect(result.class).to be CommandErrorResult
        expect(result.error_message).to eq "No command provided!"
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with empty argv array" do
      let(:argv) { [] }

      it "returns CommandErrorResult" do
        result = execute
        
        expect(result.class).to be CommandErrorResult
        expect(result.error_message).to eq "No command provided!"
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with show existing gem" do
      let(:argv) { ["show", "rspec"] }

      it "returns ShowCommandResult" do
        result = execute

        expect(result.class).to be ShowCommandResult
        expect(result.gem.name).to eq "rspec"
        expect(result.gem.info).to eq "BDD for Ruby"
        expect(result.exit_code).to eq 0
      end
    end

    context "with show inexisting gem" do
      let(:argv) { ["show", "non_existing_gem"] }

      it "returns CommandErrorResult" do
        result = execute

        expect(result.class).to be CommandErrorResult
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with show command but multiple arguments" do
      let(:argv) { ["show", "rspec", "sinatra", "rails"] }

      it "returns CommandErrorResult" do
        result = execute

        expect(result.class).to be CommandErrorResult
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with search valid keyword" do
      let(:argv) { ["search", "rspec"] }

      it "returns SearchCommandResult" do
        result = execute

        expect(result.class).to be SearchCommandResult
        expect(result.gems.size).not_to eq 0
        expect(result.exit_code).to eq 0
      end
    end

    context "with search invalid keyword" do
      let(:argv) { ["search", "non_existing_gem"] }

      it "raises SearchCommandResult" do
        result = execute

        expect(result.class).to be SearchCommandResult
        expect(result.gems.class).to be Array
        expect(result.gems.size).to eq 0
        expect(result.exit_code).to eq 0
      end
    end

    context "with search command but multiple arguments" do
      let(:argv) { ["search", "rspec", "sinatra", "rails"] }

      it "returns SearchCommandResult for the first argument" do
        result = execute

        expect(result.class).to be SearchCommandResult
        expect(result.gems.size).not_to eq 0
        expect(result.exit_code).to eq 0
      end
    end

    context "with search command and --license option" do
      let(:argv) { %w[search rspec --license MIT] }

      it "returns SearchCommandResult with gems containing specified license" do
        result = execute

        expect(result.class).to be SearchCommandResult
        expect(result.gems.size).not_to eq 0
        expect(result.exit_code).to eq 0
      end
    end

    context "with search command and --license option, but with not existing license" do
      let(:argv) { %w[search rspec --license NOT_EXISTING_LICENSE] }

      it "returns SearchCommandResult with empty array of gems" do
        result = execute

        expect(result.class).to be SearchCommandResult
        expect(result.gems.size).to eq 0
        expect(result.exit_code).to eq 0
      end
    end

    context "with search command and --most-downloads-first option" do
      let(:argv) { %w[search rspec --most-downloads-first] }

      it "returns SearchCommandResult with gems ordered by most downloads first" do
        result = execute

        expect(result.class).to be SearchCommandResult
        expect(result.gems.size).not_to eq 0
        expect(result.exit_code).to eq 0
      end
    end

    context "with search command and --most-downloads-first, --license options" do
      let(:argv) { %w[search rspec --most-downloads-first --license MIT] }

      it "returns SearchCommandResult with gems ordered by most downloads first and containing specified license" do
        result = execute

        expect(result.class).to be SearchCommandResult
        expect(result.gems.size).not_to eq 0
        expect(result.exit_code).to eq 0
      end
    end

    context "with search command and --most-downloads-first, --license, --not-existing-option options" do
      let(:argv) { %w[search rspec --not-existing-option --most-downloads-first --license MIT] }

      it "returns CommandErrorResult" do
        result = execute

        expect(result.class).to be CommandErrorResult
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with search command and --not-existing-option option" do
      let(:argv) { %w[search rspec --not-existing-option] }

      it "returns CommandErrorResult" do
        result = execute

        expect(result.class).to be CommandErrorResult
        expect(result.exit_code).not_to eq 0
      end
    end

  end
end
