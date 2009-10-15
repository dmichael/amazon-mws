
#include REXML  # so that we don't have to prefix everything with REXML::..

module Amazon
  module MWS
    class Base
      DEFAULT_HOST = "mws.amazonaws.com"

      # Wraps the current connection's request method and picks the appropriate response class to wrap the response in.
      # If the response is an error, it will raise that error as an exception. All such exceptions can be caught by rescuing
      # their superclass, the ResponseError exception class.
      #
      # It is unlikely that you would call this method directly. Subclasses of Base have convenience methods for each http request verb
      # that wrap calls to request.
      def self.request(verb, path, query_params = {}, body = nil, attempts = 0, &block)
        # Find the connection method in connection/management.rb which is evaled into Amazon::MWS::Base
        response = connection.request(verb, path, query_params, body, attempts, &block)
        body     = response.body
        
        formatted_response = 
        if response.content_type =~ /xml/
          parse_xml_response(body) 
        else
          body
        end
        
        return formatted_response
      rescue InternalError, RequestTimeout
        if attempts == 3
          raise
        else
          attempts += 1
          retry
        end
      end
      
      def self.parse_xml_response(response)
        xml = REXML::Document.new(response)
        
        # Note: we are dropping the root node which is ALWAYS "#{action}Response"
        # We should think about dropping the next node which is always "#{action}Result"
        parse_xml(xml.root)
      end
      
      def self.parse_xml(xml, hash = {})
        if xml.elements.size.zero?
          return xml.text
        else
          xml.each_element { |element|
            hash[element.name] = parse_xml(element)
          }
        end
        
        return hash
      end

      # Make some convenience methods
      [:get, :post, :put, :delete, :head].each do |verb|
        class_eval(<<-EVAL, __FILE__, __LINE__)
          def self.#{verb}(path, query_params = {}, body = nil, &block)
            request(:#{verb}, path, query_params, body, &block)
          end
        EVAL
      end
    end
    
  end
end