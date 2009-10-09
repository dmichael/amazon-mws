module Amazon
  module MWS
    
    class Connection
      def initialize(options = {})
        @options = Options.new(options)
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
      
      class Options < Hash #:nodoc:
        VALID_OPTIONS = [:access_key_id, :secret_access_key, :merchant_id, :marketplace_id, :server, :use_ssl].freeze

        def initialize(options = {})
          super()
          self.validate(options)
          self.replace(:server => DEFAULT_HOST, :port => (options[:use_ssl] ? 443 : 80))
          self.merge!(options)
        end

        def validate(options)
          invalid_options = options.keys - VALID_OPTIONS
          raise InvalidConnectionOption.new(invalid_options) unless invalid_options.empty?
        end
      end
      # Options
    end
    # Connection
  end
end

