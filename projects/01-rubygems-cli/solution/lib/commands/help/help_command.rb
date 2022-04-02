require "./lib/commands/results/command_result"
require "./lib/api/ruby_gems_api"
require "./lib/commands/results/help_command_result"

class HelpCommand
  class << self
    def execute()
      HelpCommandResult.new()
    end
  end
end
