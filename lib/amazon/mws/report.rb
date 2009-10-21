module Amazon
  module MWS

    class Report
      include Enumerations
      class << self
    
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
            
        response = Amazon::MWS::Base.get("/", query_params)
        
        RequestReportResponse.format(response)
      end
      # add a nice method
      alias_method :request, :request_report

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
        response = 
        Amazon::MWS::Base.get("/", {"Action" => "GetReportRequestList"}.merge(params))
        
        GetReportRequestListResponse.format(response)
      end
      # add a nice method
      alias_method :request_list, :get_report_request_list
    
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
         Amazon::MWS::Base.post("/", {
           "Action"   => "GetReportListByNextToken", 
           "NextToken" => next_token
         })

         GetReportRequestListByNextTokenResponse.format(response)
      end

      alias_method :request_list_by_next_token, :get_report_request_list_by_next_token      
    
      # GetReportRequestCount
      # The GetReportRequestCount returns a count of report requests.
    
      def get_report_request_count(params = {})
        response = Amazon::MWS::Base.get("/", {"Action" => "GetReportRequestCount"})
        
        GetReportRequestCountResponse.format(response)
      end
      # add a nice method
      alias_method :request_count, :get_report_request_count
    
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
        response = 
        Amazon::MWS::Base.post("/", {"Action" => "CancelReportRequests"}.merge(params))

        CancelReportRequestsResponse.format(response)
      end

      alias_method :cancel_requests, :cancel_report_requests
      
      
      
      
      
         
      def get_report(report_id, params = {})
        response = Amazon::MWS::Base.get("/", {"Action" => "GetReport", "ReportId" => report_id})
      end
    
      def get_report_count(params = {})
        response = Amazon::MWS::Base.get("/", {"Action" => "GetReportCount"})
      end
    
      def get_report_list(params = {})
        response = Amazon::MWS::Base.get("/", {"Action" => "GetReportList"})
      end
    end
    
    end
  end
end