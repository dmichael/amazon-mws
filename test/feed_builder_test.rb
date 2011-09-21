require File.join(File.dirname(__FILE__), 'test_helper')

class FeedTest < Test::Unit::TestCase
  def setup
  end
  
  def test_nothing
    msgs = [
      { "Product" => "somethinglame", 
        "NestedHash" => {"hash"=> 7},
        "NestedArray" => [{"NA1"=> 1}, {"NA2"=> 2}]
    } ,
      { "Product" => "lame1", 
        "NestedHash" => {"hash"=> 8},
        "NestedArray" => [{"NA1"=> 1}, {"NA2"=> 2}]
    } ,
    ];
    puts AWS::MWS::FeedBuilder.new(:product, msgs).render
    # puts feed.xml
  end
end
