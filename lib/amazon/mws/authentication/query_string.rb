class Amazon::MWS::Authentication  
  
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
  
end
