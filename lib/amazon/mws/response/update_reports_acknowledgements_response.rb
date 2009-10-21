module Amazon
  module MWS

    class UpdateReportAcknowledgementsResponse < Response
      xml_name "UpdateReportAcknowledgementsResponse"
      result = "UpdateReportAcknowledgementsResult"

      xml_reader :count, :as => Integer, :in => result
      xml_reader :reports, :as => [ReportInfo], :in => result
      xml_reader :request_id, :in => "ResponseMetadata"
    end
    
  end
end
