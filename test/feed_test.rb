require File.join(File.dirname(__FILE__), 'test_helper')

class FeedTest < Test::Unit::TestCase
  def setup
  end
  
  def test_nothing
    puts AWS::MWS::Feed.new.render
    # puts feed.xml
  end
end