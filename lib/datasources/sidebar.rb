# 5 "Best" design links, every day http://sidebar.io/
module DataSources
  class Sidebar
    attr_reader :url, :name
    def initialize(url_reader)
      @name = "Design"
      @url_reader = url_reader
      @url = "http://sidebar.io"
      @feed = "http://feeds.feedburner.com/SidebarFeed?format=xml"
    end

    def get_links(limit = 5)
      doc = Nokogiri::HTML(@url_reader.get(@feed))

      links = []

      #sidebar has multiple html documents, 1 per day
      data = doc.css("body").first

      data.css("a.post-title").each do |link|
        title = link.content
        anchor = link['href']
        links << Link.new(anchor, title)
      end

      links[0, limit]
    end

  end
end
