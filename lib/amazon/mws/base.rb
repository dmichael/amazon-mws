module Amazon
  module MWS
    class Base
      DEFAULT_HOST = "mws.amazon.com"
      
      class << self
        # Wraps the current connection's request method and picks the appropriate response class to wrap the response in.
        # If the response is an error, it will raise that error as an exception. All such exceptions can be caught by rescuing
        # their superclass, the ResponseError exception class.
        #
        # It is unlikely that you would call this method directly. Subclasses of Base have convenience methods for each http request verb
        # that wrap calls to request.
        def request(verb, path, options = {}, body = nil, attempts = 0, &block)
          response = connection.request(verb, path, options, body, attempts, &block)
        # Once in a while, a request to S3 returns an internal error. A glitch in the matrix I presume. Since these 
        # errors are few and far between the request method will rescue InternalErrors the first three times they encouter them
        # and will retry the request again. Most of the time the second attempt will work.
        rescue InternalError, RequestTimeout
          if attempts == 3
            raise
          else
            attempts += 1
            retry
          end
        end

        [:get, :post, :put, :delete, :head].each do |verb|
          class_eval(<<-EVAL, __FILE__, __LINE__)
            def #{verb}(path, headers = {}, body = nil, &block)
              request(:#{verb}, path, headers, body, &block)
            end
          EVAL
        end
      end
      # class << self
      
    end
  end
end