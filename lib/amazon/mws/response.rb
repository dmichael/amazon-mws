module Amazon
  module MWS
    
    class Response
      include ROXML
      xml_convention :camelcase
      
      # This is the factoryish method that is called!, not new
      def self.format(response)
        if [Net::HTTPClientError, Net::HTTPServerError].any? {|error| response.is_a? error }
          return ResponseError.new(response)
        else
          return self.from_xml(response)
        end
      end
    end

  end
end