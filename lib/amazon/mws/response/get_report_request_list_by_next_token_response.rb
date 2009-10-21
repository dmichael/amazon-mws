module Amazon
  module MWS

    class GetReportRequestListByNextTokenResponse < Response
      xml_name "GetReportRequestListByNextTokenResponse"
      result = "GetReportRequestListByNextTokenResult"

      xml_reader :has_next?,  :in => result
      xml_reader :next_token, :in => result
      xml_reader :report_requests, :as => [ReportRequest], :in => result
      xml_reader :request_id, :in => "ResponseMetadata"
    end
    
  end
end
