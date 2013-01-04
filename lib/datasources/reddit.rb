require 'json'

module DataSources
  class Reddit
    attr_reader :name

    def initialize(url_reader)
      @url_reader = url_reader
      @url = "http://www.reddit.com/r/programming/new.json?sort=new"
      @name = "Reddit"
    end

    def url
      "http://www.reddit.com/r/programming"
    end

    def get_links(limit = 5)
      links = []
      text = @url_reader.get(@url)
      json = JSON.parse(text)
      things = json['data']['children'][0,5]
      things.each do |thing|
        title  = thing['data']['title']
        anchor = thing['data']['url']
        links << Link.new(anchor, title)
      end

      links
    end
  end
end
