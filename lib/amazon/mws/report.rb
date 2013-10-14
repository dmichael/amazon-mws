module Amazon
  module MWS

    module Report
      include Enumerations
      # class << self
    
      # The RequestReport operation requests the generation of a report, which
      # creates a report request. Reports are retained for 90 days.
      # Required Request Parameters
      # ReportType - The type of report to request.
      #
      # Optional Request Parameters
      # StartDate - Start of a date range used for selecting the data to report.
      # EndDate - End of a date range used for selecting the data to report.

      def request_report(report_type, params ={})
        raise InvalidReportType if !REPORT_TYPES.include?(report_type)
        # These may need to be processed
        start_date = params[:start_date]
        end_date   = params[:end_date]
      
        query_params = {
          "Action"   => "RequestReport", 
          "ReportType" => REPORT_TYPES[report_type]
        }
      
        query_params.merge!({"StartDate" => start_date}) if start_date
        query_params.merge!({"EndDate" => end_date}) if end_date
            
        response = get("/", query_params)
        
        RequestReportResponse.format(response)
      end

      # GetReportRequestList
      # --------------------
      # The GetReportRequestList operation returns a list of report requests
      # that match the query parameters.
      # 
      # Amazon MWS limits calls to 1,000 total calls per hour per seller
      # account, including calls to GetReportRequestList.
      # 
      # The maximum number of results that will be returned in one call is one
      # hundred. If there are additional results to return, HasNext will be
      # returned in the response with a true value. To retrieve all the
      # results, you can use the value of the NextToken parameter to call
      # GetReportRequestListByNextToken until HasNext is false.
      
      # Optional Request Parameters
      #
      # ReportRequestIdList - A structured list of report request IDs. If you
      # pass in explicit IDs in this call, the other conditions, if specified,
      # will be ignored.
      #
      # ReportTypeList - A structured ReportType list by which to filter
      # reports.
      # 
      # ReportProcessingStatusList -A structured list of report processing
      # statuses by which to filter report requests.
      # 
      # ReportProcessingStatus values:
      # 
      # _SUBMITTED_ 
      # _IN_PROGRESS_
      # _CANCELLED_
      # _DONE_
      # _DONE_NO_DATA_
      #
      # MaxCount - Maximum number of reports to return in the list. If you
      # specify a number greater than 100, the call will be rejected.
      #
      # RequestedFromDate - The earliest date you are looking for, in ISO8601
      # date format (for example, "2008-07-03T18:12:22Z" or
      # "2008-07-03T18:12:22.093-07:00").
      #
      # RequestedToDate - The most recent date you are looking for.
    
      def get_report_request_list(params = {})
        response = get("/", {"Action" => "GetReportRequestList"}.merge(params))
        GetReportRequestListResponse.format(response)
      end
      # add a nice method
      alias_method :report_request_list, :get_report_request_list
    
      # GetReportRequestListByNextToken
      # Description
      # 
      # The GetReportRequestListByNextToken operation returns a list of report
      # requests that match the query parameters, using the NextToken, which
      # was supplied by a previous call to either
      # GetReportRequestListByNextToken or a call to GetReportRequestList,
      # where the value of HasNext was true in that previous call.
      
      # NextToken
      # Token returned in a previous call to either GetReportRequestList or
      # GetReportRequestListByNextToken when the value of HasNext was true.
      
      def get_report_request_list_by_next_token(next_token)
        response = 
         post("/", {
           "Action"   => "GetReportRequestListByNextToken", 
           "NextToken" => next_token
         })

         GetReportRequestListByNextTokenResponse.format(response)
      end

      alias_method :report_request_list_by_next_token, :get_report_request_list_by_next_token      
    
      # GetReportRequestCount
      # The GetReportRequestCount returns a count of report requests.
    
      def get_report_request_count(params = {})
        response = get("/", {"Action" => "GetReportRequestCount"})
        GetReportRequestCountResponse.format(response)
      end
      # add a nice method
      alias_method :report_request_count, :get_report_request_count
    
      # CancelReportRequests
      # The CancelReportRequests operation cancels one or more report
      # requests, returning the count of the canceled report requests and the
      # report request information. You can specify a number to cancel of
      # greater than one hundred, but information will only be returned about
      # the first one hundred report requests in the list. To return metadata
      # about a greater number of canceled report requests, you can call
      # GetReportRequestList. If report requests have already begun
      # processing, they cannot be canceled.
      
      #  
      # ReportRequestIdList
      # A structured list of report request IDs. If you pass in explicit IDs in this call, the other conditions, if specified, will be ignored.
      # 
      # ReportTypeList
      # A structured ReportType list by which to filter reports.
      # 
      # ReportProcessingStatusList
      # A structured list of report processing statuses by which to filter report requests.
      # 
      # ReportProcessingStatus
      # _SUBMITTED_
      # _IN_PROGRESS_
      # _CANCELLED_
      # _DONE_
      # _DONE_NO_DATA_
      # 
      # RequestedFromDate
      # The earliest date you are looking for, in ISO8601 date format (for example, "2008-07-03T18:12:22Z" or "2008-07-03T18:12:22.093-07:00").
      # 
      # RequestedToDate
      # The most recent date you are looking for.
      
      def cancel_report_requests(params = {})
        response = get("/", {"Action" => "CancelReportRequests"}.merge(params))
        CancelReportRequestsResponse.format(response)
      end
            
      # GetReportList
      # The GetReportList operation returns a list of reports within the
      # previous 90 days that match the query parameters. The maximum number
      # of results that will be returned in one call is one hundred. If there
      # are additional results to return, HasNext will be returned in the
      # response with a true value. To retrieve all the results, you can use
      # the value of the NextToken parameter to call GetReportListByNextToken
      # until HasNext is false.
      # 
      # Request Parameters
      
      def get_report_list(params = {})
        response = get("/", {"Action" => "GetReportList"}.merge(params))
        GetReportListResponse.format(response)
      end

      alias_method :report_list, :get_report_list
      
      # GetReportCount
      # The GetReportCount operation returns a count of reports within the
      # previous 90 days that are available for the seller to download.

      #  ReportTypeList
      # A structured ReportType list by which to filter reports.
      #      
      # Acknowledged
      # Set to true to list reports that have been acknowledged with a prior
      # call to UpdateReportAcknowledgements. Set to false to list reports
      # that have not been acknowledged.
      #
      # AvailableFromDate
      # The earliest date you are looking for, in ISO8601 date format (for
      # example, "2008-07-03T18:12:22Z" or "2008-07-03T18:12:22.093-07:00").
      # 
      # AvailableToDate
      # The most recent date you are looking for.
      
      def get_report_count(params = {})
        response = get("/", {"Action" => "GetReportCount"})
        GetReportCountResponse.format(response)
      end 
      
      alias_method :report_count, :get_report_count     

      # GetReport
      # Description
      # 
      # The GetReport operation returns the contents of a report and the
      # Content-MD5 header for the returned body. Reports are retained for 90
      # days from the time they have been generated.
      # 
      # Amazon MWS limits calls to 1,000 total calls per hour per seller
      # account, including a limit of 60 calls per hour to GetReport.
      # 
      # You should compute the MD5 hash of the HTTP body and compare that with
      # the returned Content-MD5 header value. If they do not match, which
      # means the body was corrupted during transmission, you should discard
      # the result and automatically retry the call for up to three more
      # times. Please notify us if you ever see such a corrupted body. You can
      # contact us by using the contact form at http://mws.amazon.com
      # (http://mws.amazon.com). For more information, see Using the
      # Content-MD5 Header with SubmitFeed.     
      #    
      
      def get_report(report_id, params = {})
        response = get("/", {"Action" => "GetReport", "ReportId" => report_id})
        # TODO format response
      end
      alias_method :report, :get_report

      # ManageReportSchedule
      # The ManageReportSchedule operation creates, updates, or deletes a
      # report schedule for a particular report type. Currently, only order
      # reports can be scheduled.
      # 
      # Request Parameters  
      #
      # ReportType
      # The type of reports that you want to schedule generation of.
      # Currently, only order reports can be scheduled.
      #
      # Schedule
      # A string that describes how often a ReportRequest should be created.
      # The list of enumerated values is found in the enumeration topic,
      # Schedule.
      # 
      # ScheduledDate
      # The date when the next report is scheduled to run. Limited to no more
      # than 366 days in the future.
      
      def manage_report_schedule(report_type, schedule, params={})
        raise InvalidReportType if !REPORT_TYPES.include?(report_type)
        raise InvalidSchedule if !SCHEDULE.include?(schedule)
        
        response = 
        get("/", {
          "Action" => "ManageReportSchedule", 
          "Schedule" => SCHEDULE[schedule],
          "ReportType" => REPORT_TYPES[report_type]
        })
        
        ManageReportScheduleResponse.format(response)
      end
      
      # GetReportScheduleList
      # The GetReportScheduleList operation returns a list of report schedules
      # that match the query parameters. Currently, only order reports can be
      # scheduled.
      # 
      # The maximum number of results that will be returned in one call is one
      # hundred. If there are additional results to return, HasNext will be
      # returned in the response with a true value. To retrieve all the
      # results, you can use the value of the NextToken parameter to call
      # GetReportScheduleListByNextToken until HasNext is false.
      # [Note]  Note
      # 
      # For this release of Amazon MWS, only order reports can be scheduled,
      # so HasNext will always be False.
      
      
      def get_report_schedule_list(params = {})
        response = get("/", {"Action" => "GetReportScheduleList"}.merge(params))
        GetReportScheduleListResponse.format(response)
      end

      alias_method :report_schedule_list, :get_report_schedule_list
      
      
      def get_report_schedule_list_by_next_token(next_token)
        response = 
         get("/", {
           "Action"   => "GetReportScheduleListByNextToken", 
           "NextToken" => next_token
         })

         GetReportScheduleListByNextTokenResponse.format(response)
      end

      alias_method :report_schedule_list_by_next_token, :get_report_schedule_list_by_next_token      
      
      def get_report_schedule_count(params = {})
        response = get("/", {"Action" => "GetReportScheduleCount"})
        GetReportScheduleCountResponse.format(response)
      end 
      
      alias_method :report_schedule_count, :get_report_schedule_count
      
    end
    
    # end
  end
end
