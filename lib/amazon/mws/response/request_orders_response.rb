module Amazon
  module MWS
    
    class RequestOrdersResponse < Response
      #xml_name "ListOrdersResponse"
      #result = "ListOrdersResult"
     
		 	#xml_accessor :orders, [OrdersRequest], :in => result
    end
    
  end
end
