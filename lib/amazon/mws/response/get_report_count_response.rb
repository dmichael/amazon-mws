module Amazon
  module MWS
    
    class GetReportCountResponse < Response
      xml_name "GetReportCountResponse"
      result = "GetReportCountResult"

      xml_reader :count, :in => result, :as => Integer
      xml_reader :request_id, :in => "ResponseMetadata"
    end
    
  end
end