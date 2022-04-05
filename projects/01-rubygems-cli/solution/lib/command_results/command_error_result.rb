require "./lib/command_results/help_command_result"

class CommandErrorResult < HelpCommandResult
  attr_accessor :error_message

  def initialize(error_message, exit_code = 1)
    super(exit_code)
    @error_message = error_message
  end

  def output
    error_message + "\n" + super
  end
end