module Amazon
  module MWS    
    
    class Connection
      attr_accessor :options
      
      # Static/Class methods
      class << self
        def connect(options = {})
          new(options)
        end
      end
      
      def initialize(params = {})
        @server            = params[:server] || Amazon::MWS::Base::DEFAULT_HOST
        @access_key        = params["access_key"]
        @secret_access_key = params["secret_access_key"]
        @merchant_id       = params["merchant_id"]
        @marketplace_id    = params["marketplace_id"]
        
        connect
      end
      
      def connect
        @http             = Net::HTTP.new(@server, 443)
        @http.use_ssl     = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        return @http
      end
      
      # Make the request, based on the apropriate request object
      # Called from Amazon::MWS::Base
      
      def request(verb, path, headers = {}, body = nil, attempts = 0, &block)
        uri = URI.parse(path)
        # presumably this is for files
        body.rewind if body.respond_to?(:rewind) unless attempts.zero?      
        
        requester = Proc.new do |http|
          path    = prepare_path(uri, verb, headers) if attempts.zero? # Only escape the path once

          request = build_request(verb, path, headers, body)
          @http.request(request, &block)
        end
        # requester
        
        if persistent?
          @http.start unless @http.started?
          requester.call
        else
          @http.start(&requester)
        end
      rescue Errno::EPIPE, Timeout::Error, Errno::EINVAL, EOFError
        @http = create_connection
        attempts == 3 ? raise : (attempts += 1; retry)
      end
      
      # Create the signed authentication query string.
      # Add this query string to the path WITHOUT prepending the server address.
      
      def prepare_path(uri, verb, headers)
        querystring = query_string_authentication(verb, uri)
        path = "#{uri.path}?#{querystring}"
        #path = path.remove_extended unless path.valid_utf8?
        #URI.escape(path)
      end
      
      def query_string_authentication(verb, uri)        
        Authentication::QueryString.new(
          :verb              => verb,
          :uri               => uri,
          :access_key        => @access_key,
          :secret_access_key => @secret_access_key,
          :merchant_id       => @merchant_id,
          :marketplace_id    => @marketplace_id
        )
      end
      
      def build_request(http_verb, path, headers = {}, body = nil)
        builder = RequestBuilder.new(http_verb, path, headers, body)
        builder.add_user_agent
        builder.add_content_type
        builder.add_content_md5(body) unless body.nil?
        return builder.request
      end
      
      def persistent?
        false
        #@options[:persistent]
      end
    end
    # Connection
    
  end
end

