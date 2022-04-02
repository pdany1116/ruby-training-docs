class OptionMostDownloadsFirst
  NAME = "--most-downloads-first"

  def apply(gems)
    gems.sort_by { |gem| -gem.downloads }
  end
end
