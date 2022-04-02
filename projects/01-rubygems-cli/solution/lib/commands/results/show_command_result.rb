require "./lib/commands/results/command_result"

class ShowCommandResult < CommandResult
  attr_accessor :gem

  def initialize(gem, exit_code = 0)
    super(exit_code)
    @gem = gem
  end

  def output
    "#{gem.name}\n#{gem.info}"
  end
end