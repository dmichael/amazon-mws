class Amazon::MWS::Connection

  module Management #:nodoc:
    def self.included(base)
      base.cattr_accessor :connections
      base.connections = {}
      base.extend ClassMethods
    end
  
    # Manage the creation and destruction of connections for Amazon::MWS::Base and its subclasses. Connections are
    # created with establish_connection!.
    module ClassMethods
      # Creates a new connection with which to make requests to the S3 servers for the calling class.
      #   
      #   Amazon::MWS::Base.establish_connection!(
      #     :access_key_id     => '...', 
      #     :secret_access_key => '...',
      #     :merchant_id       => '...',
      #     :marketplace_id    => '...'
      #   )
      #
      # == Required arguments
      #
      # * <tt>:access_key_id</tt> - The access key id for your S3 account. Provided by Amazon.
      # * <tt>:secret_access_key</tt> - The secret access key for your S3 account. Provided by Amazon.
      # * <tt>:merchant_id</tt>
      # * <tt>:marketplace_id</tt>
      #
      # If any of these required arguments is missing, a MissingAccessKey exception will be raised.
      #
      # == Optional arguments
      #
      # * <tt>:server</tt> - The server to make requests to. You can use this to specify your bucket in the subdomain,
      # or your own domain's cname if you are using virtual hosted buckets. Defaults to <tt>mws.amazonaws.com</tt>.
      # will be implicitly set to 443, unless specified otherwise. Defaults to false.
      # * <tt>:persistent</tt> - Whether to use a persistent connection to the server. Having this on provides around a two fold 
      # performance increase but for long running processes some firewalls may find the long lived connection suspicious and close the connection.
      # If you run into connection errors, try setting <tt>:persistent</tt> to false. Defaults to false.
      #
      def establish_connection!(options = {})
        # After you've already established the default connection, just specify 
        # the difference for subsequent connections
        options = default_connection.options.merge(options) if connected?
        connections[connection_name] = Amazon::MWS::Connection.connect(options)
      end
    
      # Returns the connection for the current class, or Base's default connection if the current class does not
      # have its own connection.
      #
      # If not connection has been established yet, NoConnectionEstablished will be raised.
      def connection
        if connected?
          connections[connection_name] || default_connection
        else
          raise Amazon::MWS::NoConnectionEstablished.new
        end
      end
    
      # Returns true if a connection has been made yet.
      def connected?
        !connections.empty?
      end
    
      # Removes the connection for the current class. If there is no connection for the current class, the default
      # connection will be removed.
      def disconnect(name = connection_name)
        name       = default_connection unless connections.has_key?(name)
        connection = connections[name]
        connection.http.finish if connection.persistent?
        connections.delete(name)
      end
    
      # Clears *all* connections, from all classes, with prejudice. 
      def disconnect!
        connections.each_key {|connection| disconnect(connection)}
      end

    private
      def connection_name
        name
      end

      def default_connection_name
        'Amazon::MWS::Base'
      end

      def default_connection
        connections[default_connection_name]
      end
    end
  end

end

