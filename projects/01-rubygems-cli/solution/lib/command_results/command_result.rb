class CommandResult
  attr_accessor :exit_code

  def initialize(exit_code)
    @exit_code = exit_code
  end

  def output
  end
end
