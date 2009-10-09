class Amazon::MWS::Connection
  
  class Options < Hash #:nodoc:

    def initialize(options = {})
      super()
      self.replace(:server => Amazon::MWS::Base::DEFAULT_HOST, :port => (options[:use_ssl] ? 443 : 80))
      self.merge!(options)
    end
    
    # placeholder
    def connecting_through_proxy?
      false
    end
  end
  
end