require "./lib/commands/results/search_command_result"
require "./lib/api/ruby_gems_api"
require "./lib/commands/search/search_command_option_parser"
require "./lib/gem/gem_data"

class SearchCommand
  class << self
    def execute(argv)
      return CommandErrorResult.new("No keyword provided.") if argv.size < 1
      
      options = SearchCommandOptionParser.parse()
      results = RubyGemsApi.search_gems(argv[0])
      gems = results.map { |gem_data| GemData.new(gem_data)}
      if options[:most_downloads_first]
        gems = gems.sort_by { |gem| gem.downloads }
      end
      if options[:license]
        gems = gems.reject { |gem| !gem.licenses.include?(options[:license]) if gem.licenses }
      end

      SearchCommandResult.new(gems)
    rescue GemNotFoundError, StandardApiError => e
      CommandErrorResult.new(e.message)
    end
  end
end
