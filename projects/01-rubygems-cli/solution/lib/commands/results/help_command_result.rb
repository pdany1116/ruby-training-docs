# frozen_string_literal: true

require "./lib/commands/results/command_result"

HELP_MESSAGE = "Usage: cli.rb [COMMAND]... [OPTIONS]...\n" \
  "Commands:\n" \
  "    show [GEM NAME]    Display details about specified gem\n" \
  "    search [KEYWORD]   Display a list of all gems that match the specified keyword\n" \
  "\n" \
  "Options:\n" \
  "    <search> --licenses LICENSES\n" \
  "           Show gems containing one of the specified licenses separated by commas.\n" \
  "    <search> --most-downloads-first\n" \
  "           Order gems starting with the downloaded first.\n"           

class HelpCommandResult < CommandResult
  def initialize(exit_code = 0)
    super(exit_code)
  end

  def output
    HELP_MESSAGE
  end
end