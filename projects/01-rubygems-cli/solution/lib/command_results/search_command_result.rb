require "./lib/command_results/command_result"

class SearchCommandResult < CommandResult
  attr_accessor :gem_names

  def initialize(gem_names, exit_code = 0)
    super(exit_code)
    @gem_names = gem_names
  end

  def output
    result = ""
    gem_names.each_with_index do |name, i|
      result += "#{i + 1}. #{name}\n"
    end
    
    result
  end
end