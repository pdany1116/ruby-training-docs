require "optparse"

class SearchCommandOptionParser
  class << self
    def parse()
      options = { most_downloads_first: false, license: nil }
      
      OptionParser.new do |opts|
        opts.on("--most-downloads-first") do
            options[:most_downloads_first] = true
        end
    
        opts.on("--license LICENSE") do |license|
            options[:license] = license
        end
      end.parse!(into: options)

      options
    end
  end
end
