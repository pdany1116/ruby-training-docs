require "spec_helper"
require "./lib/show_command"

RSpec.describe ShowCommand do
  subject(:program) { described_class }

  describe ".execute" do
    subject(:execute) { program.execute(arg) }

    context "with existing gem" do
      let(:arg) { "rspec" }

      it "returns ShowCommandResult" do
        result = execute

        expect(result.class).to be ShowCommandResult
      end
    end
  end
end
