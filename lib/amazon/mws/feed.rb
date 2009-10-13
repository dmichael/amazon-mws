require 'set'

module Amazon
  module MWS
    
    class Feed
      attr_accessor :xml
  
      MESSAGE_TYPES = Set.new([
        "FulfillmentCenter",
        "Inventory",
        "OrderAcknowledgment",
        "OrderAdjustment",
        "OrderFulfillment",
        "OrderReport",
        "Override",
        "Price",
        "ProcessingReport",
        "Product",
        "ProductImage",
        "Relationship",
        "SettlementReport"
      ])
  
      OPERATION_TYPES = Set.new([
        "Update", 
        "Delete"  
      ])
  
      def initialize
        @xml = Builder::XmlMarkup.new 
      end
  
      def render(params = {})
        @xml.instruct!
        @xml.AmazonEnvelope("xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance", "xsi:noNamespaceSchemaLocation"=>"amzn-envelope.xsd") do 
          render_envelope
          # header
          render_header
          # message      
          render_message
        end 
      end
  
      def render_header(params = {})
        @xml.Header do
          @xml.MerchantIdentifier "merchant_id"
        end
      end
  
      def render_envelope(params = {})
        message_type =
          if MESSAGE_TYPES.include?(params[:message_type])
            params[:message_type]
          else
            "Unknown"
          end
      
        @xml.EffectiveDate Time.now
        @xml.MessageID
        @xml.MessageType(message_type)
        @xml.OperationType(params[:operation_type]) if params[:operation_type]
        @xml.PurgeAndReplace(params[:purge] || false)
      end
  
      def render_message(params = {})
        @xml.Message do
        end
      end
    end
    # Feed
    
  end
end