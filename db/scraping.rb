require 'open-uri'
require 'nokogiri'
USER_AGENT = "Mozilla/5.0 (Windows NT x.y; rv:10.0) Gecko/20100101 Firefox/10.0"

def scraping_links
  links = []
  url = "https://dev.to/top/year"
  html_file = URI.open(url, "User-Agent" => USER_AGENT).read
  html_doc = Nokogiri::HTML.parse(html_file)
  html_doc.search(".crayons-story__hidden-navigation-link").each do |element|
    links << "https://dev.to/#{element["href"]}"
  end
  return links
end

# def scraping_post(url)
#   new_post = Post.new(user: User.all.sample)
#   new_post.url = url
#   new_post.title = new_title(url)
#   new_post.content = read_content(url)
#   file = URI.open("https://source.unsplash.com/random/?#{new_post.title}")
#   new_post.photo.attach(io: file, filename: "photo-#{new_post.id}.png", content_type: "image/png")
#   new_post.save
#   new_post.save!
#   return new_post
# end

def new_title(url)
  html_file = URI.open(url, "User-Agent" => USER_AGENT).read
  html_doc = Nokogiri::HTML.parse(html_file)
  return html_doc.search("h1").text.strip
end

def new_content(url)
  html_file = URI.open(url, "User-Agent" => USER_AGENT).read
  html_doc = Nokogiri::HTML.parse(html_file)
  paragraphs = html_doc.search("#article-body p")
  return paragraphs.map(&:text).join("<br/>")
end
