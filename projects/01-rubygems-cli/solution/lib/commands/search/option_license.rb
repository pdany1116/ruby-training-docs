class OptionLicense
  NAME = "--license LICENSE"
  
  attr_reader :license

  def initialize(license)
    @license = license
  end

  def apply(gems)
    gems.reject { |gem| !gem.licenses.include?(@license) if gem.licenses }
  end
end
