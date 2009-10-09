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
      def establish_connection!(options = {})
        # After you've already established the default connection, just specify 
        # the difference for subsequent connections
        options = default_connection.options.merge(options) if connected?
        connections[connection_name] = Connection.connect(options)
      end
    
      # Returns the connection for the current class, or Base's default connection if the current class does not
      # have its own connection.
      #
      # If not connection has been established yet, NoConnectionEstablished will be raised.
      def connection
        if connected?
          connections[connection_name] || default_connection
        else
          raise NoConnectionEstablished
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

