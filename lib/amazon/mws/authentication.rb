module Amazon
  module MWS   
    class Authentication  
      VERSION = 2
      
      class QueryString < String #:nodoc:
        attr_accessor :request, :access_key_id, :secret_access_key, :merchant_id, :marketplace_id
        
        def initialize(request, access_key_id, secret_access_key, merchant_id, marketplace_id, options = {})
          super()
          @request           = request
          @access_key_id     = access_key_id
          @secret_access_key = secret_access_key
          @merchant_id       = merchant_id
          @marketplace_id    = marketplace_id

          self << build
        end
        
        # private
        def build
          Params.new(self).to_query_string
        end
        
        def calculate_signature
          Signature.new(@request, @secret_access_key)
        end
        
        def date
          @request['date'].to_s.strip.empty? ? Time.now : Time.parse(@request['date'])
        end
        
        class Params < Hash
          def initialize(query)
            super()
            replace(
              'AWSAccessKeyId'   => query.access_key_id,
              'Marketplace'      => query.marketplace_id,
              'Merchant'         => query.merchant_id,
              'Signature'        => query.calculate_signature,
              'SignatureMethod'  => Signature::METHOD,
              'SignatureVersion' => Signature::VERSION,
              'Timestamp'        => query.date,
              'Version'          => Authentication::VERSION
            )
          end
        end
        # Params
      end
      # QueryString
      
      class Signature < String #:nodoc:
        VERSION = '2009-01-01'
        METHOD  = 'HmacSHA1'
        
        def initialize(request, secret_access_key)
          super()
          @request           = request
          @request['Host']   = Amazon::MWS::Base::DEFAULT_HOST
          @secret_access_key = secret_access_key     
          @uri               = URI.parse(@request.path)

          self << build
        end
        
        def build
          digest   = OpenSSL::Digest::Digest.new('sha1')
          b64_hmac = [OpenSSL::HMAC.digest(digest, @secret_access_key, string_to_sign)].pack("m").strip
          
          # url_encode? ? CGI.escape(b64_hmac) : b64_hmac
          return b64_hmac
        end
        
        # StringToSign = HTTPVerb + "\n" + 
        #                ValueOfHostHeaderInLowercase + "\n" + 
        #                HTTPRequestURI + "\n" +         
        #                CanonicalizedQueryString <from the preceding step>
        def string_to_sign
          "#{http_verb}\n#{host_header}\n#{path}\n#{canonicalized_query_string}"
        end
        
        def http_verb
          @request.method
        end
        
        def host_header
          @request['Host']
        end
        
        def path
          @request.path[/^[^?]*/]
        end
                
        # Create the canonicalized query string that you need later in this procedure: 
        # a. Sort the UTF-8 query string components by parameter name with natural byte ordering. The 
        # parameters can come from the GET URI or from the POST body (when Content-Type is 
        # application/x-www-form-urlencoded). 
        #
        # b. URL encode the parameter name and values according to the following rules: 
        # * Do not URL encode any of the unreserved characters that RFC 3986 defines. These 
        # unreserved characters are A-Z, a-z, 0-9, hyphen ( - ), underscore ( _ ), period ( . ), and tilde 
        # ( ~ ). 
        # * Percent encode all other characters with %XY, where X and Y are hex characters 0-9 and 
        # uppercase A-F. 
        # * Percent encode extended UTF-8 characters in the form %XY%ZA.... 
        # * Percent encode the space character as %20 (and not +, as common encoding schemes 
        # do). 
        #
        # c. Separate the encoded parameter names from their encoded values with the equals sign ( = ) 
        # (ASCII character 61), even if the parameter value is empty. 
        #
        # d. Separate the name-value pairs with an ampersand ( & ) (ASCII code 38).
        def canonicalized_query_string
          return if @uri.query.nil?
          Hash.from_query_string(@uri.query).sort.to_query_string
        end
      end
      # class Signature
      
    end
  end
end