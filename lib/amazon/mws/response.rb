module Amazon
  module MWS
    
    class Response
      include ROXML
      xml_convention :camelcase
      
      # This is the factoryish method that is called!, not new
      def self.format(response)
        if response.content_type =~ /xml/ || response.body =~ /<?xml/
          parse_xml(response)  
        else
          response.body
        end
      end
      
      def self.parse_xml(response)
        if [Net::HTTPClientError, Net::HTTPServerError].any? {|error| response.is_a? error }
          return ResponseError.from_xml(response.body)
        else
          return self.from_xml(response.body)
        end
      end
      
      def accessors
        roxml_references.map {|r| r.accessor}
      end
      
    end

  end
end