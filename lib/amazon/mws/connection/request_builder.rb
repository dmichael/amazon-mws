class Amazon::MWS::Connection
  class RequestBuilder
    attr_accessor :request

    def initialize(verb, path, body = nil)
      # Create the request object
      @request = request_method(verb).new(path)
      process_body(body)
    end
    
    def request_method(verb)
      Net::HTTP.const_get(verb.to_s.capitalize)
    end    
  
    def process_body(body)
      @request.content_length = 0 and return self if body.nil?

      if body.respond_to?(:read)                                                                
        @request.body_stream = body                                                           
      else                                                                                      
        @request.body = body                                                                     
      end
      
      @request.content_length = body.respond_to?(:lstat) ? body.stat.size : body.size
      return self
    end
    
    # For the SubmitFeed (p. 41) function, we require that you pass the Content-MD5 HTTP header, 
    # which contains the MD5 hash of the HTTP entity body (see Section 14.15 of RFC 2616, the HTTP/1.1 
    # specification), so we can check if the feed we stored for processing is bit for bit identical with what you 
    # sent, protecting you from corrupted descriptive or pricing product data appearing on Amazon.com. 
    #
    def add_host
      @request['Host'] = Amazon::MWS::DEFAULT_HOST
      return self
    end
    
    def add_user_agent
      @request['User-Agent'] = "Amazon::MWS/#{Amazon::MWS::Version} (Language=Ruby)"
      return self
    end
    
    def add_content_type
      # nothing happening yet
      @request.content_type = "text/html; charset=iso-8859-1"
      return self
    end
    
    def add_content_md5(body = "")
      @request['Content-MD5'] = Base64.encode64(create_md5(body)).chomp
      return self # chainable
    end  
    
    # think about chaining this with process_body
    def create_md5(body)
      md5 = Digest::MD5.new
      
      # stream from file or in memory?
      if body.respond_to?(:read)
        digest = body.each { |line| md5.update(line) }        
      else
        digest = md5.update(body)
      end
      
      return digest.digest
    end
  end
end
