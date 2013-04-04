require 'killshot/version'
require 'rubygems'
require 'anemone'
require 'colored'
require 'nokogiri'
require 'uri'
require 'set'

module Killshot
  class Crawler
    attr_reader :root, :whitelist
    attr_accessor :hotlinks

    def initialize(root, whitelist)
      @root      = root
      @whitelist = Set.new(whitelist)
      @hotlinks  = []
    end

    def crawl!
      Anemone.crawl(root) do |anemone|
        anemone.on_every_page do |page|
          find_hotlinks(page)
        end
      end

      puts "Done. Found #{hotlinks.length} hotlinked images!"
    end

    private

    def hotlink?(img)
      src  = img['src']
      uri = URI(URI::escape(src))
      # Check if absolute, ignore relative links
      uri.absolute? && !whitelist.member?(uri.host)
    end

    def hotlink_found(page, img)
      src = img['src']
      url = page.url.to_s.green
      img = img['src'].red

      hotlinks << src
      puts "#{hotlinks.length}. #{img} from #{url}"
    end

    def find_hotlinks(page)
      doc = Nokogiri::HTML(page.body)
      doc.xpath("//img").each do |img|
        hotlink_found(page, img) if hotlink?(img)
      end
    end
  end
end
