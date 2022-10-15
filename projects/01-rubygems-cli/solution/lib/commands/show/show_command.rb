require "./lib/commands/results/show_command_result"
require "./lib/commands/results/command_error_result"
require "./lib/api/ruby_gems_api_with_cache"

class ShowCommand
  class << self
    def execute(argv)
      return CommandErrorResult.new("Too many arguments!") if argv.size > 2

      gem = RubyGemsAPIWithCache.show_gem(argv[0])

      ShowCommandResult.new(gem)
    rescue StandardError => e
      CommandErrorResult.new(e.message)
    end
  end
end
