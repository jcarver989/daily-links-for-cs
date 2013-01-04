helpers do
  def render_source(data_tuple)
    html = <<-HTML
      <div class='span4 content'>
        <h3>#{data_tuple[:name]}</h3>
        <h6><a target='_blank' href='#{data_tuple[:source_url]}'>#{format_link(data_tuple[:source_url])}</a></h6>
        <ul>
           #{render_links(data_tuple[:links])}
        </ul>
      </div>
    HTML
  end


  def render_links(links)
    html = "" 
    links.each do |link|
      html += "<li><a target='_blank' href='#{link.href}'>#{link.content}</a></li>\n"
    end

    html
  end


  def format_link(link)
    link.gsub("http://", "").gsub("www.", "")
  end
end
