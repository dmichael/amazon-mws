module Amazon
  module MWS    
    
    class Connection
      # Static/Class methods
      class << self
        def connect(options = {})
          new(options)
        end
      end
      
      def initialize(params = {})
        # These values are essential to establishing a connection
        @server            = params['server'] || Amazon::MWS::DEFAULT_HOST
        @persistent        = params['persistent'] || false
        # These values are essential to signing requests
        @access_key        = params['access_key']
        @secret_access_key = params['secret_access_key']
        @merchant_id       = params['merchant_id']
        @marketplace_id    = params['marketplace_id']
        
        raise MissingConnectionOptions if [@access_key, @secret_access_key, @merchant_id, @marketplace_id].any? {|option| option.nil?}
        
        @http = connect
      end
      
      # Create the Net::HTTP object to use for this connection
      def connect
        http             = Net::HTTP.new(@server, 443)
        http.use_ssl     = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        return http
      end
      
      # Make the request, based on the apropriate request object
      # Called from Amazon::MWS::Base
      def request(verb, path, query_params, body = nil, attempts = 0, &block)
        # presumably this is for files
        body.rewind if body.respond_to?(:rewind) unless attempts.zero?
        # Prepare the Proc to be called by Net::HTTP
        proc = requester(verb, path, query_params, body)
        
        if @persistent
          @http.start unless @http.started?
          proc.call
        else
          @http.start(&proc)
        end
      rescue Errno::EPIPE, Timeout::Error, Errno::EINVAL, EOFError
        @http = connect
        attempts == 3 ? raise : (attempts += 1; retry)
      end
      
      # A Proc used by the request method
      def requester(verb, path, query_params, body)
        Proc.new do |http|
          path    = prepare_path(verb, path, query_params)
          puts "#{path}\n\n" if AWS::MWS::Base.debug
          request = build_request(verb, path, body)
          
          @http.request(request)
        end
      end
      
      # Create the signed authentication query string.
      # Add this query string to the path WITHOUT prepending the server address.
      def prepare_path(verb, path, query_params)
        query_string = authenticate_query_string(verb, query_params)
        return "#{path}?#{query_string}"
      end
      
      # Generates the authentication query string used by Amazon.
      # Takes the http method and the query string of the request and returns the authenticated query string
      def authenticate_query_string(verb, query_params = {})        
        Authentication::QueryString.new(
          :verb              => verb,
          :query_params      => query_params,
          :access_key        => @access_key,
          :secret_access_key => @secret_access_key,
          :merchant_id       => @merchant_id,
          :marketplace_id    => @marketplace_id,
          :server            => @server
        )
      end
      
      # Builds up a Net::HTTP request object
      def build_request(verb, path, body = nil)
        builder = RequestBuilder.new(verb, path, body)
        builder.add_user_agent
        builder.add_content_type
        builder.add_content_md5(body) unless body.nil?
        
        return builder.request
      end
    end
    # Connection
    
  end
end

