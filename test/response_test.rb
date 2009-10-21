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
    
  def test_request_report
    response = RequestReportResponse.format(xml_for('request_report'))
    
    assert_equal("88faca76-b600-46d2-b53c-0c8c4533e43a", response.request_id)
    
    assert(response.report_request)
    assert_equal(response.report_request.report_type, "_GET_MERCHANT_LISTINGS_DATA_")
    assert_equal(response.report_request.scheduled?, false)
    assert_equal(response.report_request.report_processing_status, "_SUBMITTED_")
  end
  
  def test_get_report_request_list
    response = GetReportRequestListResponse.format(xml_for('get_report_request_list'))
    
    assert_equal(response.request_id, "1e1d7b22-004e-4333-a881-1f20b671097f")
    assert(response.has_next?)
    assert_equal(response.next_token, "gTw92cRxgz0D2s1QD6a1Fdz+0b6t4r6aM48r5nOh7ZQ2cKWBkRSk57AfQiDLYYb/tts/YTgAGXw7u4xT348+ZoSJ8NeAlfpOrrBJpKO2HAHCv/LqsB0EzxybTwcKfw+6oQjX0m4upU+Q1A2v3FCYQ1eWYigAJMzhvZSqczZdpQRFrR1eNdlVGQ==")
    assert_equal(response.report_requests.size, 10)
  end
  
  def test_get_report_request_list_by_next_token
    response = GetReportRequestListByNextTokenResponse.format(xml_for('get_report_request_list_by_next_token'))
    
    assert_equal("732480cb-84a8-4c15-9084-a46bd9a0889b", response.request_id)
    assert_equal('none', response.next_token)
    assert_equal(false, response.has_next?) # same as false ???

    assert_equal(1, response.report_requests.size)
    assert_equal(2291326454, response.report_requests.first.id)
    assert_equal('732480cb-84a8-4c15-9084-a46bd9a0889b', response.request_id)
  end

  def test_get_report_request_count
    response = GetReportRequestCountResponse.format(xml_for('get_report_request_count'))
  
    assert_equal(1276, response.count)
    assert_equal('7e155027-3741-4422-95a7-1de12703c13e', response.request_id)
  end
  
  def test_cancel_report_requests
    response = CancelReportRequestsResponse.format(xml_for('cancel_report_requests'))
  
    assert_equal(10, response.count)
    assert_equal(1, response.report_requests.size)
    assert_equal('a720f9d6-83e9-4684-bc35-065b41ed5ca4', response.request_id)
  end
  
  def test_get_report_list_response
    response = GetReportListResponse.format(xml_for('get_report_list'))
    
    assert_equal("fbf677c1-dcee-4110-bc88-2ba3702e331b", response.request_id)
    assert(response.has_next?)
    #assert_equal(response.next_token, "2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=")
    assert_equal(response.reports.size, 1)
    
    assert_equal(898899473, response.reports.first.id)
    assert_equal('_GET_MERCHANT_LISTINGS_DATA_', response.reports.first.type)
    assert_equal(2278662938, response.reports.first.report_request_id)
    assert_equal(Time.parse('Tue Feb 10 04:22:33 -0500 2009'), response.reports.first.available_date)
    assert_equal(response.reports.first.acknowledged?, false)
  end
  
  def test_get_report_count
    response = GetReportCountResponse.format(xml_for('get_report_count'))
  
    assert_equal(166, response.count)
    assert_equal('a497aadb-5ea1-49bf-aa14-dabe914465e3', response.request_id)
  end
  
  def test_manage_report_schedule
    response = ManageReportScheduleResponse.format(xml_for('manage_report_schedule'))
  
    assert_equal(1, response.count)
    assert_equal('7ee1bc50-5a13-4db1-afd7-1386e481984e', response.request_id)

    assert(response.report_schedule)
    assert_equal('_GET_ORDERS_DATA_', response.report_schedule.report_type)
    assert_equal('_30_DAYS_', response.report_schedule.schedule) 
    assert_equal(Time.parse('2009-02-20T02:10:42+00:00'), response.report_schedule.scheduled_date)
  end
  
  def test_get_report_schedule_list_response
    response = GetReportScheduleListResponse.format(xml_for('get_report_schedule_list'))
    
    assert_equal("c0464157-b74f-4e52-bd1a-4ebf4bc7e5aa", response.request_id)
    assert(response.has_next?)
    assert_equal("4XgYW55IPQhcm5hbCBwbGVhc3VyZS4=", response.next_token)
    
    assert_equal(response.report_schedules.size, 1)
    
    assert_equal('_GET_ORDERS_DATA_', response.report_schedules[0].report_type)
    assert_equal('_30_DAYS_', response.report_schedules[0].schedule) 
    assert_equal(Time.parse('2009-02-20T02:10:42+00:00'), response.report_schedules[0].scheduled_date)
  end
  
  def test_get_report_schedule_list_by_next_token
    response = GetReportScheduleListByNextTokenResponse.format(xml_for('get_report_schedule_list_by_next_token'))
    
    assert_equal("c0464157-b74f-4e52-bd1a-4ebf4bc7e5aa", response.request_id)
    assert_equal('none', response.next_token)
    assert_equal(false, response.has_next?) # same as false ???

    assert_equal(1, response.report_schedules.size)
    # assert_equal(13050620, response.report_schedules[0].id)
    assert_equal('c0464157-b74f-4e52-bd1a-4ebf4bc7e5aa', response.request_id)
  end
  
  def test_get_report_schedule_count
    response = GetReportScheduleCountResponse.format(xml_for('get_report_schedule_count'))
  
    assert_equal(18, response.count)
    assert_equal('21e482a8-15c7-4da3-91a4-424995ed0756', response.request_id)
  end
  
  def test_update_report_acknowledgements
    response = UpdateReportAcknowledgementsResponse.format(xml_for('update_report_acknowledgements'))
  
    assert_equal(1, response.count)
    assert_equal('42a578a7-ed92-486b-ac67-5de7464fcdfa', response.request_id)
    assert(response.reports)
  end
  
end

