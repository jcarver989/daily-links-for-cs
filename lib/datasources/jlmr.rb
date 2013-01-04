# Journal of Machine Learning Research 
# http://jmlr.csail.mit.edu/papers/

module DataSources
  class JLMR
    attr_reader :url, :name
    @@version = 13

    def initialize(url_reader)
      @name = "Machine Learning"
      @url_reader = url_reader
      @url = "http://jmlr.csail.mit.edu/papers/v#{@@version}/"
    end

    def get_links(limit = 5)
      doc = Nokogiri::HTML(@url_reader.get(@url))
      links = []

      papers = doc.css("#content dl")
      papers.each do |paper|
        title = paper.css("dt").first.content

        # first is the abstract
        anchor = paper.css("dd a").last['href']
        links << Link.new(anchor, title)
      end

      links[0, limit]
    end
  end
end
