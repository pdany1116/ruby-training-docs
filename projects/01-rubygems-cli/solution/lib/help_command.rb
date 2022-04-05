require "./lib/command_results/command_result"
require "./lib/ruby_gems_api"
require "./lib/command_results/help_command_result"

class HelpCommand
  class << self
    def execute()
      HelpCommandResult.new()
    end
  end
end
