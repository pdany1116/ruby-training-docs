require "./lib/api/gem_data"
require "./lib/api/ruby_gems_api_with_cache"
require "./lib/commands/results/search_command_result"
require "./lib/commands/search/option_parser_search_command"

class SearchCommand
  class << self
    def execute(argv)
      return CommandErrorResult.new("No keyword provided.") if argv.size < 1
      
      options = OptionParserSearchCommand.parse(argv[1..])
      gems = RubyGemsAPIWithCache.search_gems(argv[0])
      options.each do |option|
        gems = option.apply(gems)
      end

      SearchCommandResult.new(gems)
    rescue GemNotFoundError, StandardAPIError, OptionParser::ParseError => e
      CommandErrorResult.new(e.message)
    end
  end
end
