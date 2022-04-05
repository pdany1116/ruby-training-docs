require "./lib/command_results/search_command_result"
require "./lib/ruby_gems_api"

class SearchCommand
  class << self
    def execute(arg)
      begin
        result = RubyGemsApi.search_gems(arg)
      rescue StandardError => e
        CommandErrorResult.new(e.message)
      else
        gem_names = result.map { |gem| gem["name"] }
        SearchCommandResult.new(gem_names)
      end
    end
  end
end
