require File.join(File.dirname(__FILE__), 'test_helper')
require 'yaml'


# import the namespace
include Amazon::MWS
  
class FeedTest < Test::Unit::TestCase
  def setup
    config = YAML.load_file( File.join(File.dirname(__FILE__), '../lib/amazon/mws.yml') )
    
    AWS::MWS::Base.establish_connection!(
      config['production']
    )
    AWS::MWS::Base.debug = true
  end
  
  def test_request
    #response = Report.request(:flat_file_orders)
    
    #result = Report.request(:flat_file_orders, :start_date => Time.now, :end_date => Time.now.iso8601)
    
    result = Report.request_list
    
    puts result.inspect
  end
  
  
end