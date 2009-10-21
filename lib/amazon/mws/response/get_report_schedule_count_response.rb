module Amazon
  module MWS
    
    class GetReportScheduleCountResponse < Response
      xml_name "GetReportScheduleCountResponse"
      result = "GetReportScheduleCountResult"

      xml_reader :count, :in => result, :as => Integer
      xml_reader :request_id, :in => "ResponseMetadata"
    end
    
  end
end