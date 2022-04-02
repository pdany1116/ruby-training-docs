class GemData
  attr_accessor :name, :info, :downloads, :licenses

  def initialize(gem_data)
    @name = gem_data["name"]
    @info = gem_data["info"]
    @downloads = gem_data["downloads"]
    @licenses = gem_data["licenses"]
  end
end
