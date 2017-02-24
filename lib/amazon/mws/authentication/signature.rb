class Amazon::MWS::Authentication
  
  class Signature < String # :nodoc:
    extend Memoizable
    
    VERSION = '2'
    METHOD  = 'HmacSHA256'

    def initialize(queryparams = {}, params = {})
      verb = params[:verb]

      # The secret access key is required so that the signing process can
      # be initialized
      secret = params[:secret_access_key]
      raise Amazon::MWS::MissingAccessKey.new(params) if secret.nil?

      host = params[:server]

      # Create the string to sign
      string = string_to_sign(verb, canonical_querystring(queryparams), host)
      self << sign(string, secret)
    end
  
    # Returns a signed string
    def sign(string, secret_access_key)
      hmac = HMAC::SHA256.new(secret_access_key)
      hmac.update(string)
      # chomp is important!  the base64 encoded version will have a newline at the end
      Base64.encode64(hmac.digest).chomp
    end
    
    memoize :sign
    
    def string_to_sign(verb, querystring, host)
      verb = verb.to_s.upcase
      string = "#{verb}\n#{host}\n/\n#{querystring}"
      puts string if Amazon::MWS::Base.debug
      string
    end
    
    memoize :string_to_sign

    def canonical_querystring(params)
      # Make sure we have string keys, otherwise the sort does not work
      params = Hash.keys_to_s(params)
      params.sort.collect { |key, value| [CGI.escape(key.to_s), CGI.escape(value.to_s)].join('=') }.join('&')
    end
    
    memoize :canonical_querystring
  end
  
end
