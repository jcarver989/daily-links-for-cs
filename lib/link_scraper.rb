require './lib/datasources'

class LinkScraper
  def initialize(minutes_until_cache_expires = 30)
    @cache = DataSources::CachedURIReader.new(minutes_until_cache_expires) # 30 minutes
  end

  def scrape_links
    links = {} 
    threads = []

    threads << Thread.new do 
      topic = :artificial_intelligenceand_machine_learning
      source = DataSources::GoogleResearch.new("Google: AI & ML", @cache, topic)
      links[:google_ai] = data_tuple(source)
    end

    threads << Thread.new do 
      topic = :distributed_systemsand_parallel_computing
      source = DataSources::GoogleResearch.new("Google: Dist. Systems", @cache, topic)
      links[:google_dist_systems] = data_tuple(source)
    end

    threads << Thread.new do
      source = DataSources::Sidebar.new(@cache)
      links[:sidebar] = data_tuple(source) 
    end

    threads << Thread.new do
      source = DataSources::JLMR.new(@cache)
      links[:jlmr] = data_tuple(source)
    end

    threads << Thread.new do
      source = DataSources::Reddit.new(@cache)
      links[:reddit] = data_tuple(source)
    end

    feeds = [
      ["Dzone", "http://feeds.dzone.com/dzone/frontpage?format=atom"],
      ["Scala", "http://www.planetscala.com/atom.xml"],
      ["JavaScript", "http://feeds.feedburner.com/dailyjs?format=atom"],
      ["CSS", "http://feeds.feedburner.com/CssTricks?format=atom"]
    ]

    feeds.each do |feed_data|
      threads << Thread.new do 
        name, url = feed_data
        feed = DataSources::AtomFeed.new(name, @cache, url)
        links[name.downcase.to_sym] = data_tuple(feed)
      end
    end

    threads.each { |t| t.join }
    links
  end

  private 

  def data_tuple(source)
    { 
      :name       => source.name, 
      :source_url => source.url, 
      :links      => source.get_links 
    }
  end
end
