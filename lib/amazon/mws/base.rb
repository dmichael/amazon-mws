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
      def self.request(verb, path, body = nil, attempts = 0, &block)
        # Find the connection method in connection/management.rb which is evaled into Amazon::MWS::Base
        response = connection.request(verb, path, body, attempts, &block)
  
      rescue InternalError, RequestTimeout
        if attempts == 3
          raise
        else
          attempts += 1
          retry
        end
      end

      # Make some convenience methods
      [:get, :post, :put, :delete, :head].each do |verb|
        class_eval(<<-EVAL, __FILE__, __LINE__)
          def self.#{verb}(path, body = nil, &block)
            request(:#{verb}, path, body, &block)
          end
        EVAL
      end
    end
    
  end
end