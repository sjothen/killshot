require "rubygems"
require "minitest/autorun"
require "killshot"

# Modified from http://blog.jayfields.com/2007/11/ruby-testing-private-methods.html
class Class
  def publicize
    saved_private_instance_methods = self.private_instance_methods
    self.class_eval { public(*saved_private_instance_methods) }
    yield self
    self.class_eval { private(*saved_private_instance_methods) }
  end
end

class TestHotlinks < MiniTest::Unit::TestCase
  def test_hotlink
    Killshot::Crawler.publicize do |klass|
      ks = klass.new("http://blah.com", ["blah.com"])
 
      assert ks.hotlink?("http://notblah.com")
      assert ks.hotlink?("http://abc.com/url")
    end
  end

  def test_hotlink_whitelist
    Killshot::Crawler.publicize do |klass|
      ks = klass.new("http://blah.com", ["blah.com", "notblah.com", "abc.com"])
 
      refute ks.hotlink?("http://notblah.com")
      refute ks.hotlink?("http://abc.com/url")
      refute ks.hotlink?("http://blah.com")
    end
  end

  def test_nothotlinks
    Killshot::Crawler.publicize do |klass|
      ks = klass.new("http://blah.com", ["blah.com"])
 
      refute ks.hotlink?("http://blah.com/test1/test2/")
      refute ks.hotlink?("/relative/url")
      refute ks.hotlink?("relative-url.html")
    end
  end
end
