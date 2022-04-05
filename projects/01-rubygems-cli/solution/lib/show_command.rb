require "./lib/command_results/show_command_result"
require "./lib/command_results/command_error_result"
require "./lib/ruby_gems_api"

class ShowCommand
  class << self
    def execute(arg)
      begin
        result = RubyGemsApi.gem_info(arg)
      rescue StandardError => e
        CommandErrorResult.new(e.message)
      else
        ShowCommandResult.new(result["name"], result["info"])
      end
    end
  end
end
