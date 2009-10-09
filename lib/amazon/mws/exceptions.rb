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
    
  end
end