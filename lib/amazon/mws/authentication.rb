class Amazon::MWS::Authentication  
  VERSION = '2009-01-01'
  
  class QueryString < String
    def initialize(params = {})
      queryparams = {
        'AWSAccessKeyId'   => params[:access_key],
        'Marketplace'      => params[:marketplace_id],
        'Merchant'         => params[:merchant_id],
        'SignatureMethod'  => Signature::METHOD,
        'SignatureVersion' => Signature::VERSION,
        'Timestamp'        => Time.now.iso8601,
        'Version'          => Amazon::MWS::Authentication::VERSION
      }
      
      # Add any params that are passed in via uri before calculating the signature
      query = params[:uri].query || ""
      queryparams = queryparams.merge(Hash.from_query_string(query))
      
      # Calculate the signature
      queryparams['Signature'] = Signature.new(queryparams, params)
      
      self << formatted_querystring(queryparams)
    end
    
    def formatted_querystring(queryparams)
      queryparams.collect { |key, value| [CGI.escape(key.to_s), CGI.escape(value.to_s)].join('=') }.join('&') # order doesn't matter for the actual request
    end
  end
  # QueryString
  
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
