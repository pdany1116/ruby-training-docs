# frozen_string_literal: true

require "./lib/command_results/command_result"

HELP_MESSAGE = "Usage example:\n" \
  "    show [GEM NAME]    Display details about specified gem\n" \
  "    search [KEYWORD]   Display a list of all gems that match the specified keyword\n"

class HelpCommandResult < CommandResult
  def initialize(exit_code = 0)
    super(exit_code)
  end

  def output
    HELP_MESSAGE
  end
end