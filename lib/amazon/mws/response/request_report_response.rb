module Amazon
  module MWS
    
    class RequestReportResponse < Response
      xml_name "RequestReportResponse"
      result = "RequestReportResult"


      xml_reader :request_id, :in => "ResponseMetadata"      
      xml_reader :report_request, :in => result, :as => ReportRequest
    end
    
  end
end
