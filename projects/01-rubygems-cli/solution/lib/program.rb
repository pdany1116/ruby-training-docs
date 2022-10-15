require "./lib/commands/show/show_command"
require "./lib/commands/search/search_command"
require "./lib/commands/help/help_command"
require "./lib/commands/results/command_error_result"

class Program
  class << self
    def execute(argv)
      argv = argv.compact.reject(&:empty?)
      return CommandErrorResult.new("No command provided!", 1) if argv.empty?

      case argv[0]
      when "show"
        ShowCommand.execute(argv[1..])
      when "search"
        SearchCommand.execute(argv[1..])
      when "help"
        HelpCommand.execute
      else
        CommandErrorResult.new("Invalid option #{argv[0]}!", 1)
      end
    end
  end
end
