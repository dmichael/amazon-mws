module Amazon
  module MWS
    
    class ResponseError < Response
      xml_name "ErrorResponse"
      
      xml_reader :type, :in => "Error"
      xml_reader :code, :in => "Error"    
      xml_reader :message, :in => "Error"    
      xml_reader :detail, :in => "Error"
      xml_reader :request_id   
    end
    
  end
end