require 'rss'

module DataSources
  class AtomFeed
    attr_reader :name

    def initialize(name, url_reader, url)
      @name = name
      @url = url
      @url_reader = url_reader
    end

    def url
      doc = Nokogiri::HTML(@url_reader.get(@url))
      link = doc.css("channel link").first || doc.css("link").first
      link['href'] || @url
    end

    def get_links(limit = 5)
      begin
        get_links_rss()[0, limit]
      rescue Exception => e
        p e
        get_links_fallback()[0, limit]
      end
    end

    private

    def get_links_rss
      rss = RSS::Parser.parse(@url_reader.get(@url))
      links = []

      rss.items.each do |item| 
        anchor = (item.link.respond_to?(:href))? item.link.href : item.link
        title  = (item.title.respond_to?(:content))? item.title.content : item.title
        links << Link.new(anchor, title)
      end

      links
    end

    # fallback method for rss feeds with syntax errors
    def get_links_fallback
      doc = Nokogiri::HTML(@url_reader.get(@url))
      links = []

      entries = doc.css("entry")
      entries.each do |entry|
        title = entry.css("title").first.content
        anchor = entry.css("link[rel='alternate']").first['href']
        links << Link.new(anchor, title)
      end

      links
    end
  end
end
