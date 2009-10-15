require File.join(File.dirname(__FILE__), 'test_helper')

class FeedTest < Test::Unit::TestCase
  def setup
  end
  
  def test_nothing
    puts AWS::MWS::FeedBuilder.new(:product, {
      "Product" => "somethinglame", 
      "NestedHash" => {"hash"=> 7},
      "NestedArray" => [{"NA1"=> 1}, {"NA2"=> 2}]
      }).render
    # puts feed.xml
  end
end