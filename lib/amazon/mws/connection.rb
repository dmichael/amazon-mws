module Amazon
  module MWS    
    
    class Connection
      attr_accessor :options
      
      # Static/Class methods
      class << self
        def connect(options = {})
          new(options)
        end
      
        def prepare_path(path)
          path = path.remove_extended unless path.valid_utf8?
          URI.escape(path)
        end
      end
      
      def initialize(options = {})
        @options = Options.new(options)
        connect
      end
      
      def connect
        extract_keys!
        @http = create_connection
      end
      
      def extract_keys!
        missing_keys = []
        extract_key  = Proc.new {|key| @options[key] || (missing_keys.push(key); nil)}
        @access_key_id     = extract_key["aws_access_key"]
        @secret_access_key = extract_key["aws_secret_access_key"]
        @access_key_id     = extract_key["merchant_id"]
        @secret_access_key = extract_key["marketplace_id"]
        raise MissingAccessKey.new(missing_keys) unless missing_keys.empty?
      end
      
      def create_connection
        http             = http_class.new(@options[:server], @options[:port])
        http.use_ssl     = !@options[:use_ssl].nil? || @options[:port] == 443
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        return http
      end
      
      # Proxies are not yet implemented
      def http_class
        if options.connecting_through_proxy?
          Net::HTTP::Proxy(*options.proxy_settings)
        else
          Net::HTTP
        end
      end
      
      def build_request(verb, path, headers = {}, body = nil)
        builder = RequestBuilder.new(verb, path, headers, body)
        builder.add_user_agent.add_content_type
        builder.add_content_md5(body) unless body.nil?
        return builder.request
      end

      # Make the request, based on the apropriate request object
      def request(verb, path, headers = {}, body = nil, attempts = 0, &block)
        # presumably this is for files
        body.rewind if body.respond_to?(:rewind) unless attempts.zero?      
        
        requester = Proc.new do |http|
          puts "YE!"
          path    = self.class.prepare_path(path) if attempts.zero? # Only escape the path once
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
      # request
      
      def persistent?
        @options[:persistent]
      end

      def url_for(path, options = {})
        path         = self.class.prepare_path(path)
        request      = request_method(:get).new(path, {})
        query_string = query_string_authentication(request, options)
        returning "#{protocol(options)}#{http.address}#{port_string}#{path}" do |url|
          url << "?#{query_string}" if authenticate
        end
      end
      
      def query_string_authentication(request, options = {})
        Authentication::QueryString.new(request, access_key_id, secret_access_key, merchant_id, marketplace_id, options)
      end
      
      def url_for(path, options = {})
        request      = request_method(:get).new(path, {})
        query_string = query_string_authentication(request, options)
        
        return "#{protocol(options)}#{http.address}#{port_string}#{path}?#{query_string}"
      end
      
      def protocol(options = {})
        # This always trumps http.use_ssl?
        if options[:use_ssl] == false 
          'http://'
        elsif options[:use_ssl] || http.use_ssl?
          'https://'
        else
          'http://'
        end
      end

      def port_string
        default_port = options[:use_ssl] ? 443 : 80
        http.port == default_port ? '' : ":#{http.port}"
      end
 
      def query_string_authentication(request, options = {})
        Authentication::QueryString.new(request, access_key_id, secret_access_key, options)
      end

    end
    # Connection
    
  end
end

