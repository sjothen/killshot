require "rubygems"
require "anemone"
require "trollop"
require "nokogiri"
require "colored"
require "uri"
require "set"

opts = Trollop::options do
  opt :root, "URL where we start crawling", :type => :string
  opt :allowed, "Comma separated list of allowed domains", :type => :strings
end

Trollop::die :root, "must be given" if opts[:root].nil?
Trollop::die :allowed, "must be given" if opts[:allowed].nil?

$allowed = Set.new(opts[:allowed])
$count = 0

def hotlink?(img)
  src = img["src"]
  # Check if absolute, ignore relative links
  if src =~ %r"^http://"
    host = URI(src).host
    return (not $allowed.member?(host))
  else
    return false
  end
end

def show_hotlink(page, img)
  url = page.url.to_s.green
  img = img["src"].red
  puts "#{$count}. #{img} from #{url}"
end

def find_hotlinks(p)
  doc = Nokogiri::HTML(p.body)
  doc.xpath("//img").each do |img|
    if hotlink?(img)
      $count += 1
      show_hotlink(p, img)
    end
  end
end

Anemone.crawl(opts[:root]) do |anemone|
  anemone.on_every_page do |page|
    find_hotlinks(page)
  end
end

puts "Done. Found #{$count} hotlinked images!"