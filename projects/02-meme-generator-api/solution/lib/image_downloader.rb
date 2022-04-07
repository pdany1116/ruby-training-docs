require "down"

class ImageDownloader
  class << self
    def download(uri, path)
      Down.download(uri, destination: path)
    end
  end
end
