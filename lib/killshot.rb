require 'killshot/version'
require 'rubygems'
require 'anemone'
require 'colored'
require 'nokogiri'
require 'uri'
require 'set'

module Killshot
  class Crawler
    attr_reader :opts, :whitelist
    attr_accessor :count

    def initialize(opts)
      @opts      = opts
      @whitelist = Set.new(opts[:whitelist])
      @count     = 0
    end

    def crawl!
      Anemone.crawl(opts[:root]) do |anemone|
        anemone.on_every_page do |page|
          find_hotlinks(page)
        end
      end

      puts "Done. Found #{count} hotlinked images!"
    end

    private

    def hotlink?(img)
      src  = img["src"]
      uri = URI(URI::escape(src))
      # Check if absolute, ignore relative links
      uri.absolute? && !whitelist.member?(uri.host)
    end

    def show_hotlink(page, img)
      url = page.url.to_s.green
      img = img["src"].red
      puts "#{count}. #{img} from #{url}"
    end

    def find_hotlinks(p)
      doc = Nokogiri::HTML(p.body)
      doc.xpath("//img").each do |img|
        if hotlink?(img)
          @count += 1
          show_hotlink(p, img)
        end
      end
    end
  end
end
