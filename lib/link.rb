class Link
  attr_reader :href, :content

  def initialize(href, content)
    @href = href
    @content = content
  end

  def to_s
    "#{@href} -  #{@content}" 
  end
end
