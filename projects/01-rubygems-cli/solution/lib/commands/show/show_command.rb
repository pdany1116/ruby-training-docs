require "./lib/commands/results/show_command_result"
require "./lib/commands/results/command_error_result"
require "./lib/api/ruby_gems_api"

class ShowCommand
  class << self
    def execute(argv)
      return CommandErrorResult.new("Too many arguments!") if argv.size > 2
      begin
        result = RubyGemsApi.gem_info(argv[0])
      rescue StandardError => e
        CommandErrorResult.new(e.message)
      else
        ShowCommandResult.new(result["name"], result["info"])
      end
    end
  end
end
