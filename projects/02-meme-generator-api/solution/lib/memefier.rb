require "mini_magick"

class Memefier
  class << self
    def memefy(source = "./tmp/original.jpeg", destination = "./tmp/meme.jpeg", text)
      image = MiniMagick::Image.open(source)
      
      image.combine_options do |options|
        options.gravity "south"
        options.font "Umpush-Bold"
        options.fill "White"
        options.pointsize "100"
        options.stroke "Black"
        options.strokewidth "2"
        options.draw "text 0,0 '#{text}'"
      end

      image.write(destination)
    end
  end
end
