module Amazon
  module MWS
    
    # Abstract super class of all Amazon::MWS exceptions
    class MWSException < StandardError
    end
    
    # Abstract super class for all invalid options.
    class InvalidOption < MWSException
    end
    
    # Raised if an unrecognized option is passed when establishing a connection.
    class InvalidConnectionOption < InvalidOption
      def initialize(invalid_options)
        message = "The following connection options are invalid: #{invalid_options.join(', ')}. "    +
                  "The valid connection options are: #{Connection::Options::VALID_OPTIONS.join(', ')}."
        super(message)
      end
    end
    
    # Raised if either the access key id or secret access key arguments are missing when establishing a connection.
    class MissingAccessKey < InvalidOption
      def initialize(missing_keys)
        key_list = missing_keys.map {|key| key.to_s}.join(' and the ')
        super("You did not provide both required access keys. Please provide the #{key_list}.")
      end
    end
    
    # Raised if a request is attempted before any connections have been established.
    class NoConnectionEstablished < MWSException
    end
        
  end
end