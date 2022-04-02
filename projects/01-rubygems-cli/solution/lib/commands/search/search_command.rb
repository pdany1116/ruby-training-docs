require "./lib/commands/results/search_command_result"
require "./lib/api/ruby_gems_api"
require "./lib/commands/search/option_parser_search_command"
require "./lib/gem/gem_data"

class SearchCommand
  class << self
    def execute(argv)
      return CommandErrorResult.new("No keyword provided.") if argv.size < 1
      
      options = OptionParserSearchCommand.parse(argv[1..])
      results = RubyGemsApi.search_gems(argv[0])
      gems = results.map { |gem_data| GemData.new(gem_data)}
      options.each do |option|
        gems = option.apply(gems)
      end

      SearchCommandResult.new(gems)
    rescue GemNotFoundError, StandardAPIError => e
      CommandErrorResult.new(e.message)
    end
  end
end
