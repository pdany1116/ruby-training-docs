class OptionLicense
  NAME = "--licenses LICENSES"
  
  attr_reader :licenses

  def initialize(licenses)
    @licenses = licenses
  end

  def apply(gems)
    gems.select { |gem| gem.licenses and gem.licenses.intersection(@licenses).any? }
  end
end
