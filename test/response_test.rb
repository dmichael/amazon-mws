require File.join(File.dirname(__FILE__), 'test_helper')

include Amazon::MWS

class ResponseTest < Test::Unit::TestCase
  
  def test_submit_feed_response
    response = SubmitFeedResponse.format(xml_for('submit_feed'))
    
    assert_equal(response.feed_submission.id, 2291326430)
    assert_equal(response.feed_submission.feed_type, '_POST_PRODUCT_DATA_')
    assert_equal(response.request_id, '75424a38-f333-4105-98f0-2aa9592d665c')
  end

  def test_feed_submission_list_response
    response = GetFeedSubmissionListResponse.format(xml_for('get_feed_submission_list'))
    
    assert_equal("1105b931-6f1c-4480-8e97-f3b467840a9e", response.request_id)
    assert(response.has_next?)
    assert_equal(response.next_token, "2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=")
    assert_equal(response.feed_submissions.size, 1)
    assert_equal(response.feed_submissions.first.id, 2291326430)
  end
  
  def test_get_feed_submission_list_by_next_token
    response = GetFeedSubmissionListByNextTokenResponse.format(xml_for('get_feed_submission_list_by_next_token'))
    
    assert_equal("1105b931-6f1c-4480-8e97-f3b467840a9e", response.request_id)
    assert_equal(false, response.has_next?) # same as false ???
    assert_equal('none', response.next_token)
    assert_equal(response.feed_submissions.size, 1)
    assert_equal(response.feed_submissions.first.id, 2291326430)
    assert_equal('1105b931-6f1c-4480-8e97-f3b467840a9e', response.request_id)
  end
  
  def test_get_feed_submission_count
    response = GetFeedSubmissionCountResponse.format(xml_for('get_feed_submission_count'))
  
    assert_equal(463, response.count)
    assert_equal('21e482a8-15c7-4da3-91a4-424995ed0756', response.request_id)
  end
  
  def test_cancel_feed_submissions
    response = CancelFeedSubmissionsResponse.format(xml_for('cancel_feed_submissions'))
  
    assert_equal(1, response.count)
    assert_equal(1, response.feed_submissions.size)
    assert_equal('18e78983-bbf9-43aa-a661-ae7696cb49d4', response.request_id)
  end
    
  def test_get_feed_submission_result
    response = GetFeedSubmissionResultResponse.format(xml_for('get_feed_submission_result'))
    assert_equal(1.02, response.document_version)
    assert_equal('M_EXAMPLE_9876543210', response.merchant_id)
    
    assert_equal('ProcessingReport', response.message_type)
    
    assert_equal(1, response.message.id)
    assert_equal(2060950676, response.message.document_transaction_id)
    assert_equal("Complete", response.message.status_code)
    
    assert_equal(0, response.message.processing_summary.messages_processed)   
    assert_equal(0, response.message.processing_summary.messages_successful)    
    assert_equal(1, response.message.processing_summary.messages_with_error)    
    assert_equal(0, response.message.processing_summary.messages_with_warning)
    
    assert_equal(0, response.message.result.message_id)
    assert_equal('Error', response.message.result.result_code)
    assert_equal(6001, response.message.result.message_code)
    assert_equal('XML parsing fatal error at line 1, column 1: Invalid document structure', response.message.result.description)
    assert_equal(0, response.message.result.sku)
  end
    
    
  def test_report_request_list_response
    response = ReportRequestListResponse.format(xml_for('get_report_request_list'))
    
    assert_equal(response.request_id, "1e1d7b22-004e-4333-a881-1f20b671097f")
    assert(response.has_next?)
    assert_equal(response.next_token, "gTw92cRxgz0D2s1QD6a1Fdz+0b6t4r6aM48r5nOh7ZQ2cKWBkRSk57AfQiDLYYb/tts/YTgAGXw7u4xT348+ZoSJ8NeAlfpOrrBJpKO2HAHCv/LqsB0EzxybTwcKfw+6oQjX0m4upU+Q1A2v3FCYQ1eWYigAJMzhvZSqczZdpQRFrR1eNdlVGQ==")
    assert_equal(response.report_requests.size, 10)
  end
  
  def test_report_request_list_response
    
  end

end

