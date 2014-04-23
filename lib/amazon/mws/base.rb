module Amazon
  module MWS
    DEFAULT_HOST = "mws.amazonaws.com"
    
    class Base
      attr_accessor :connection
      
      def self.debug; @@debug ||= false end
      def self.debug=(bool); @@debug = bool end
      
      def initialize(options ={})
        @merchant_id = options['merchant_id']
        raise "Must supply merchant_id" unless @merchant_id
        @connection = Amazon::MWS::Connection.connect(options)
      end
      
      def connection
        raise Amazon::MWS::NoConnectionEstablished.new if !connected?
        @connection
      end

      def connected?
        !@connection.nil?
      end

      def disconnect
        @connection.http.finish if @connection.persistent?
        @connection = nil
      end
      
      # Wraps the current connection's request method and picks the appropriate response class to wrap the response in.
      # If the response is an error, it will raise that error as an exception. All such exceptions can be caught by rescuing
      # their superclass, the ResponseError exception class.
      #
      # It is unlikely that you would call this method directly. Subclasses of Base have convenience methods for each http request verb
      # that wrap calls to request.
      def request(verb, path, query_params = {}, body = nil, attempts = 0, &block)
        # Find the connection method in connection/management.rb which is evaled into Amazon::MWS::Base
        response = @connection.request(verb, path, query_params, body, attempts, &block)
        
        # Each calling class is responsible for formatting the result
        return response
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
          def #{verb}(path, query_params = {}, body = nil, &block)
            request(:#{verb}, path, query_params, body, &block)
          end
        EVAL
      end
    end
    
  end
end
