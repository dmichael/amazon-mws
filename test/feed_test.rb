require File.join(File.dirname(__FILE__), 'test_helper')
require 'yaml'

#include AWS::MWS

class FeedTest < Test::Unit::TestCase 
  def setup
    config = YAML.load_file( File.join(File.dirname(__FILE__), '../lib/amazon/mws.yml') )
    
    AWS::MWS::Base.establish_connection!(
      config['production']
    )
  end
  
  def test_submit_feed
    response = Feed.submit
    #response = Feed.submit_feed
  end
  
  def test_get_feed_submission_list
    response = Feed.submission_list
    #response = Feed.get_feed_submission_list
  end
  
  def test_get_feed_submission_list_by_next_token
    response = Feed.submission_list_by_next_token
    #response = Feed.get_feed_submission_list_by_next_token
  end
  
  def test_get_feed_submission_list_by_next_token
    response = Feed.submission_list_by_next_token
    #response = Feed.get_feed_submission_list_by_next_token
  end
  
  def test_get_feed_submission_count
    response = Feed.submission_count
    #response = Feed.get_feed_submission_count
  end

  
  def test_cancel_feed_submissions
    response = Feed.cancel_submissions
    #response = Feed.cancel_feed_submissions
  end
  
  def test_get_feed_submission_result
    response = Feed.submission_result
    #response = Feed.get_feed_submission_result
  end
end