require "down"

class ImageDownloader
  class << self
    def download(uri, path = "./tmp/original.jpeg")
      Down.download(uri, destination: path)
    end
  end
end
