require File.join(File.dirname(__FILE__), 'test_helper')
require 'yaml'

class RequestTest < Test::Unit::TestCase
  def setup
    config = YAML.load_file( File.join(File.dirname(__FILE__), '../lib/amazon/mws.yml') )
    
    Amazon::MWS::Base.establish_connection!(
      config['production']
    )
  end
  
  def test_first
    response = Amazon::MWS::Base.get("/?Action=GetReportCount")
    puts response
  end

end