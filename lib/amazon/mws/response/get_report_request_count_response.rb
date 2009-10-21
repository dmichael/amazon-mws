module Amazon
  module MWS
    
    class GetReportRequestCountResponse < Response
      xml_name "GetReportRequestCountResponse"
      result = "GetReportRequestCountResult"

      xml_reader :count, :in => result, :as => Integer
      xml_reader :request_id, :in => "ResponseMetadata"
    end
    
  end
end