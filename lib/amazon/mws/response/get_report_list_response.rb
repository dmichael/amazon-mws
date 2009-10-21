module Amazon
  module MWS

    class GetReportListResponse < Response
      xml_name "GetReportListResponse"
      result = "GetReportListResult"

      xml_reader :has_next?, :in => result
      xml_reader :next_token, :in => result
      xml_reader :reports, :as => [ReportInfo], :in => result
      xml_reader :request_id, :in => "ResponseMetadata"
    end
    
  end
end