require "./lib/api"

Dir.mkdir("./tmp/") unless Dir.exists?("./tmp/")
API.run
