module Amazon
  module MWS    
    
    class Connection
      def self.connect(options = {})
        new(options)
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
        extract_key  = Proc.new {|key| options[key] || (missing_keys.push(key); nil)}
        @access_key_id     = extract_key[:access_key_id]
        @secret_access_key = extract_key[:secret_access_key]
        @access_key_id     = extract_key[:merchant_id]
        @secret_access_key = extract_key[:marketplace_id]
        raise MissingAccessKey.new(missing_keys) unless missing_keys.empty?
      end
      
      def create_connection
        http             = http_class.new(options[:server], options[:port])
        http.use_ssl     = !options[:use_ssl].nil? || options[:port] == 443
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end
      
      def http_class
        if options.connecting_through_proxy?
          Net::HTTP::Proxy(*options.proxy_settings)
        else
          Net::HTTP
        end
      end
      
      def request
        url = URI.parse("http://www.whatismyip.com/automation/n09230945.asp")

        req = request_method(:get).new(url.path)
        req.add_field("X-Forwarded-For", "0.0.0.0")

        res = Net::HTTP.new(url.host, url.port).start do |http|
          http.request(req)
        end
      end
      
      def request_method(verb)
        Net::HTTP.const_get(verb.to_s.capitalize)
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

      def ensure_content_type!(request)
        request['Content-Type'] ||= 'binary/octet-stream'
      end
      
      # Just do Header authentication for now
      def authenticate!(request)
        request['Authorization'] = Authentication::Header.new(request, access_key_id, secret_access_key)
      end
      
      def add_user_agent!(request)
        request['User-Agent'] ||= "AWS::S3/#{Version}"
      end
      
      def query_string_authentication(request, options = {})
        Authentication::QueryString.new(request, access_key_id, secret_access_key, options)
      end

      def request_method(verb)
        Net::HTTP.const_get(verb.to_s.capitalize)
      end
      
      def method_missing(method, *args, &block)
        options[method] || super
      end
    end
    # Connection
    
  end
end

