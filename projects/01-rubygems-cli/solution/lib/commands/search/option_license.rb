class OptionLicense
  NAME = "--license LICENSE"
  
  attr_reader :license

  def initialize(license)
    @license = license
  end

  def apply(gems)
    gems.select { |gem| gem.licenses and gem.licenses.include?(@license) }
  end
end
