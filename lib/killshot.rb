require 'killshot/version'
require 'rubygems'
require 'anemone'
require 'nokogiri'
require 'uri'
require 'set'

module Killshot
  class Crawler
    attr_reader :root, :whitelist

    def initialize(root, whitelist)
      @root      = root
      @whitelist = Set.new(whitelist)
    end

    def crawl(&block)
      Anemone.crawl(root) do |anemone|
        anemone.on_every_page do |page|
          find_hotlinks(page) do |url, hotlink|
            block.call(url, hotlink)
          end
        end
      end
    end

    private

    def hotlink?(imgsrc)
      uri = URI(URI::escape(imgsrc))
      # Check if absolute, ignore relative links
      uri.absolute? && !whitelist.member?(uri.host)
    end

    def find_hotlinks(page, &block)
      doc = Nokogiri::HTML(page.body)
      doc.xpath("//img").each do |img|
        block.call(page.url.to_s, img['src']) if hotlink?(img['src'])
      end
    end
  end

  class Printer
    def initialize
      @count = 0 
    end 

    def print(url, img)
      @count = @count + 1 
      puts "#@count. #{img.red} from #{url.green}"
    end 

    def start
      puts "Searching for hotlinks..."
    end 

    def finish
      puts "Done. Found #@count hotlinks."
    end 
  end
end
