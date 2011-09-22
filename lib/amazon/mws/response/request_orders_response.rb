module Amazon
  module MWS
    
    class RequestOrdersResponse < Response
      xml_name "RequestOrdersResponse"
      result = "RequestOrdersResult"


      xml_reader :request_id, :in => "ResponseMetadata"      
      xml_reader :report_request, :in => result, :as => OrdersRequest
    end
    
  end
end
