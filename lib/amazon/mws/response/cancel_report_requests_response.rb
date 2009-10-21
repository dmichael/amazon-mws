module Amazon
  module MWS

    class CancelReportRequestsResponse < Response
      xml_name "CancelReportRequestsResponse"
      result = "CancelReportRequestsResult"

      xml_reader :count, :in => result, :as => Integer
      xml_reader :report_requests, :as => [ReportRequest], :in => result
      xml_reader :request_id, :in => "ResponseMetadata"
    end
    
  end
end