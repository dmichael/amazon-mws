class Amazon::MWS::Connection
  
  class Options < Hash #:nodoc:
    VALID_OPTIONS = [:access_key_id, :secret_access_key, :merchant_id, :marketplace_id, :server, :use_ssl].freeze

    def initialize(options = {})
      super()
      self.validate(options)
      self.replace(:server => DEFAULT_HOST, :port => (options[:use_ssl] ? 443 : 80))
      self.merge!(options)
    end
    
    # placeholder
    def connecting_through_proxy?
      false
    end
    
    def validate(options)
      invalid_options = options.keys - VALID_OPTIONS
      raise InvalidConnectionOption.new(invalid_options) unless invalid_options.empty?
    end
  end
  
end