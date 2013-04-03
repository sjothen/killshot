require "rubygems"
require "anemone"
require "trollop"
require "nokogiri"
require "colored"
require "uri"
require "set"

opts = Trollop::options do
  version "killshot 0.0.1 (c) Stephen Michael Jothen"
  banner <<-EOS
Killshot helps you find, and kill any hotlinks on a given domain.

Usage:
EOS

  opt :root, "URL where we start crawling", :type => :string
  opt :whitelist, "List of allowed domains", :type => :strings
end

Trollop::die :root, "must be given" if opts[:root].nil?
Trollop::die :whitelist, "must be given" if opts[:whitelist].nil?

$whitelist = Set.new(opts[:whitelist])
$count = 0

def hotlink?(img)
  src  = img["src"]
  uri = URI(URI::escape(src))
  # Check if absolute, ignore relative links
  uri.absolute? && !$whitelist.member?(uri.host)
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
