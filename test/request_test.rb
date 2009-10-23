require File.join(File.dirname(__FILE__), 'test_helper')
require 'yaml'

AWS::MWS::Base.debug = true

class RequestTest < Test::Unit::TestCase
  def setup
    config = YAML.load_file( File.join(File.dirname(__FILE__), '../lib/amazon/mws.yml') )
    
    @marketplace = AWS::MWS::Base.new(config['production'])
  end
  
  def test_first
    response = @marketplace.request_report(:converged_flat_file_order_report)
    response = @marketplace.get_report_request_list('MaxCount' => 100)
  end

end