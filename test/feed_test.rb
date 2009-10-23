require File.join(File.dirname(__FILE__), 'test_helper')
# flatten the namespace
require 'mocha'
include AWS::MWS

AWS::MWS::Base.debug = true

class FeedTest < Test::Unit::TestCase 
  def setup
    config = YAML.load_file( File.join(File.dirname(__FILE__), 'test_config.yml') )
    @marketplace = AWS::MWS::Base.new(config)
  end
  
  #def test_submit_feed
    #response = Feed.submit
    #response = Feed.submit_feed
  #end
      
  def test_get_feed_submission_list_failure
    @marketplace.stubs(:get).returns(
      mock_response(401, :body => File.read(xml_for('error')), :content_type => "text/xml")
    )

    response = @marketplace.submission_list
    assert_kind_of(ResponseError, response)
  end    
  
  def test_get_feed_submission_list_success
    @marketplace.stubs(:get).returns(
      mock_response(200, :body => File.read(xml_for('get_feed_submission_list')), :content_type => "text/xml")
    )
    
    response = @marketplace.submission_list
    assert_kind_of(GetFeedSubmissionListResponse, response)
  end
  
=begin    
  def test_get_feed_submission_list_by_next_token
    #response = Feed.submission_list_by_next_token
    #response = Feed.get_feed_submission_list_by_next_token
  end
  
  def test_get_feed_submission_list_by_next_token
    #response = Feed.submission_list_by_next_token
    #response = Feed.get_feed_submission_list_by_next_token
  end
  
  def test_get_feed_submission_count
    #response = Feed.submission_count
    #response = Feed.get_feed_submission_count
  end

  
  def test_cancel_feed_submissions
    #response = Feed.cancel_submissions
    #response = Feed.cancel_feed_submissions
  end
  
  def test_get_feed_submission_result
    #response = Feed.submission_result
    #response = Feed.get_feed_submission_result
  end
=end
end