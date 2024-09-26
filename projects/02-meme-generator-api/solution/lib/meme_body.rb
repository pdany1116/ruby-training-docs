require "uri"

class MemeBody
  attr_accessor :uri, :text

  def initialize(uri, text)
    @uri = uri
    @text = text
  end

  def file_name
    File.basename(URI.parse(uri).path)
  end
end
