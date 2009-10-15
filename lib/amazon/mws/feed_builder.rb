require 'set'

module Amazon
  module MWS
    
    class FeedBuilder
      attr_accessor :xml
  
      OPERATION_TYPES = Set.new([
        "Update", 
        "Delete"  
      ])
  
      def initialize(message_type, message = {}, params = {})
        @xml = Builder::XmlMarkup.new 
        @message_type = message_type
        @message = message
        @params = params
      end
      
      def render  
        @xml.instruct!
        @xml.AmazonEnvelope("xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance", "xsi:noNamespaceSchemaLocation"=>"amzn-envelope.xsd") do 
          render_envelope(:message_type => @message_type)
          # header
          render_header(@params)
          # message      
          render_message(@message, @params)
        end
      end
  
      def render_header(params = {})
        @xml.Header do
          @xml.MerchantIdentifier "merchant_id"
        end
      end
  
      def render_envelope(params = {})      
        @xml.EffectiveDate Time.now
        @xml.MessageID
        @xml.MessageType(params[:message_type])
        @xml.OperationType(params[:operation_type]) if params[:operation_type]
        @xml.PurgeAndReplace(params[:purge] || false)
      end
  
      def render_message(message, params = {})
        raise unless message.is_a? Hash
        
        @xml.Message do |xml|
          build_xml(message, xml)
        end
      end
      
      def build_xml(hash, xml)
        hash.each {|key, value|
          case value
            when Hash  then xml.tag!(key) {|xml| build_xml(value, xml) }
            when Array then xml.tag!(key) {|xml| value.each {|v| build_xml(v, xml) } }
            else xml.tag!(key, value)
          end
        }
      end
    end
    # Feed
    
  end
end