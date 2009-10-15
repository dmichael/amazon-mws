require File.join(File.dirname(__FILE__), 'test_helper')
require 'yaml'

class FeedSubmissionTest < Test::Unit::TestCase
  def setup
    config = YAML.load_file( File.join(File.dirname(__FILE__), '../lib/amazon/mws.yml') )
    
    AWS::MWS::Base.establish_connection!(
      config['production']
    )
  end
  
  def test_get_feed_submission_list
    # Amazon::MWS::API.submit_feed(:product_data, :product, @product)
    # response = Amazon::MWS::API.get_feed_submission_list
  end
end