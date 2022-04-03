require "./lib/commands/results/command_result"

class SearchCommandResult < CommandResult
  attr_accessor :gems

  def initialize(gems, exit_code = 0)
    super(exit_code)
    @gems = gems
  end

  def output
    result = ""
    gems.each_with_index do |gem, i|
      result += "#{i + 1}. #{gem.name}\n"
    end
    
    result
  end
end
