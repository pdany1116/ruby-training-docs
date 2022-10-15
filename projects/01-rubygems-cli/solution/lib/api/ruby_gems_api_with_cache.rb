require "./lib/cache/db_cache"
require "./lib/api/ruby_gems_api"

class RubyGemsAPIWithCache
  class << self
    SHOW_ACTION = "show"
    SEARCH_ACTION = "search"

    def show_gem(gem_name)
      key = cache_key(gem_name, SHOW_ACTION)
      entry = cache.read(key)
      return GemData.new(JSON.parse(entry.value)) if entry

      gem = RubyGemsAPI.show_gem(gem_name)
      cache.write(key, JSON.dump(gem.raw_data))

      gem
    end

    def search_gems(keyword)
      key = cache_key(keyword, SEARCH_ACTION)
      entry = cache.read(key)
      return JSON.parse(entry.value).map { |gem| GemData.new(gem) } if entry

      gems = RubyGemsAPI.search_gems(keyword)
      raw_data = gems.map { |gem| gem.raw_data }
      cache.write(key, JSON.dump(raw_data))

      gems
    end

    private

    def cache
      DBCache.create
    end

    def cache_key(*args)
      Digest::MD5.hexdigest(args.join(''))
    end
  end
end
