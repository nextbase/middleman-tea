@articles ||= blog.articles[0..5]
title = settings.tea[:blog][:name]
subtitle = settings.tea[:blog][:description]

xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = settings.tea[:blog][:url]
  xml.title @tagname.present? ? "#{title}: #{@tagname}" : title
  xml.subtitle @tagname.present? ? "Posts tagged with #{@tagname}" : subtitle
  xml.id URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, current_page.path), "rel" => "self"
  xml.updated blog.articles.first.date.to_time.iso8601
  xml.author { xml.name settings.tea[:author][:name] }

  @articles.each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => URI.join(site_url, article.url)
      xml.id URI.join(site_url, article.url)
      xml.published article.date.to_time.iso8601
      xml.updated File.mtime(article.source_file).iso8601
      xml.author { xml.name settings.tea[:author][:name] }
      xml.summary summary(article), "type" => "html"
      # Use article.body if you haven't Nokogiri available
      # xml.content article.body, "type" => "html"
    end
  end
end
