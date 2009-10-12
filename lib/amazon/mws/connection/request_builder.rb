class Amazon::MWS::Connection
  class RequestBuilder
    attr_accessor :request

    def initialize(verb, path, headers = {}, body = nil)
      @request = request_method(verb).new(path, headers)
      @body = body
      process_body
    end
    
  
    def process_body
      @request.content_length = 0 and return self if @body.nil?

      if @body.respond_to?(:read)                                                                
        @request.body_stream = @body                                                           
      else                                                                                      
        @request.body = @body                                                                     
      end
      
      @request.content_length = @body.respond_to?(:lstat) ? @body.stat.size : @body.size
      return self
    end
    
    def request_method(verb)
      Net::HTTP.const_get(verb.to_s.capitalize)
    end
    
    # For the SubmitFeed (p. 41) function, we require that you pass the Content-MD5 HTTP header, 
    # which contains the MD5 hash of the HTTP entity body (see Section 14.15 of RFC 2616, the HTTP/1.1 
    # specification), so we can check if the feed we stored for processing is bit for bit identical with what you 
    # sent, protecting you from corrupted descriptive or pricing product data appearing on Amazon.com. 
    #
    def add_host
      @request['Host'] = Amazon::MWS::Base::DEFAULT_HOST
      return self
    end
    
    def add_user_agent
      @request['User-Agent'] = "Amazon::MWS/#{Amazon::MWS::Version} (Language=Ruby)"
      return self
    end
    
    def add_content_type
      @request['Content-Type'] = 'binary/octet-stream'
      return self
    end
    
    def add_content_md5
      @request['Content-MD5']  = Base64.encode64(@body) unless @body.nil?
      return self
    end  
  end
end