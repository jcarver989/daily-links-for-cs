# Most recent Google Research papers

module DataSources
  class GoogleResearch
    attr_reader :url, :name

    def initialize(name, url_reader, topic)
      @name = name
      @url_reader = url_reader
      page = "#{topic.to_s.split("_").map { |t| t.capitalize }.join("")}.html"
      @url = "http://research.google.com/pubs/#{page}"
    end

    def get_links(limit = 5)
      doc = Nokogiri::HTML(@url_reader.get(@url))
      links = []

      papers = doc.css("ul.pub-list a.pdf-icon")
      papers.each do |paper|
        title  = paper.parent.css("p.pub-title").first.content
        anchor = paper['href']
        links << Link.new("http://research.google.com" + anchor, title)
      end

      links[0, limit]
    end
  end
end
