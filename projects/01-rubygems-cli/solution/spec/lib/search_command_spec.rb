require "spec_helper"
require "./lib/search_command"

RSpec.describe SearchCommand do
  subject(:program) { described_class }

  describe ".execute" do
    subject(:execute) { program.execute(arg) }

    context "with valid keyword" do
      let(:arg) { "rspec" }

      it "returns SearchCommandResult" do
        result = execute

        expect(result.class).to be SearchCommandResult
      end
    end
  end
end
