require "optparse"
require "./lib/commands/search/option_license"
require "./lib/commands/search/option_most_downloads_first"

class OptionParserSearchCommand
  class << self
    def parse(args)
      options = []
      
      OptionParser.new do |opts|
        opts.on(OptionMostDownloadsFirst::NAME) do
          options.push(OptionMostDownloadsFirst.new)
        end
    
        opts.on(OptionLicense::NAME) do |license|
          options.push(OptionLicense.new(license))
        end
      end.parse!(args)

      options
    end
  end
end