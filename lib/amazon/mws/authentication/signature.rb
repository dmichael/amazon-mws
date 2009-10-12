class Amazon::MWS::Authentication
  
  class Signature < String #:nodoc:
    VERSION = '2'
    METHOD  = 'HmacSHA256'

    def initialize(queryparams = {}, params = {})
      verb   = params[:verb]
      secret = params[:secret_access_key]
      # Create the string to sign
      string = string_to_sign(verb, canonical_querystring(queryparams))
      self << sign(string, secret)
    end
    
    # Returns a signed string
    def sign(string, secret_access_key)
      hmac = HMAC::SHA256.new(secret_access_key)
      hmac.update(string)
      # chomp is important!  the base64 encoded version will have a newline at the end
      Base64.encode64(hmac.digest).chomp
    end

    def string_to_sign(verb, querystring)
      verb   = verb.to_s.upcase
      string = "#{verb}\n#{Amazon::MWS::Base::DEFAULT_HOST}\n/\n#{querystring}"
    end

    def canonical_querystring(params)
      params.sort.collect { |key, value| [CGI.escape(key.to_s), CGI.escape(value.to_s)].join('=') }.join('&')
    end
  end
  
end
