module DataSources
  class CachedURIReader
    def initialize(minutes_to_cache = 30) 
      @cache_threshold = minutes_to_cache * 60
      @cache = {}
    end

    def get(url)
      cache(url) if @cache[url].nil? || time_to_update_cache(url)
      @cache[url][:data]
    end

    private
    def time_to_update_cache(url)
      seconds_since_last_cache = Time.now - @cache[url][:last_cached]
      seconds_since_last_cache >= @cache_threshold
    end

    def cache(url)
      @cache[url] = { :data => open(url).read, :last_cached => Time.now }
    end
  end
end
