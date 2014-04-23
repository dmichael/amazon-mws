module Amazon
  module MWS

    class GetFeedSubmissionResultResponse < Response
      class Header < Response
        xml_reader :document_version, :as => Float
        xml_reader :merchant_id, :from => "MerchantIdentifier"
      end
      
      class ProcessingSummary < Response
        xml_name "ProcessingSummary"
      
        xml_reader :messages_processed,    :as => Integer
        xml_reader :messages_successful,   :as => Integer
        xml_reader :messages_with_error,   :as => Integer
        xml_reader :messages_with_warning, :as => Integer
      end
      
      class Result < Response
        xml_name "Result"
      
        xml_reader :message_id, :from => "MessageID", :as => Integer
        xml_reader :result_code
        xml_reader :message_code, :from => "ResultMessageCode", :as => Integer
        xml_reader :description, :from => "ResultDescription"
        xml_reader :sku, :from => "SKU", :in => "AdditionalInfo"
      end
      
      class Message < Response
        xml_name "Message"
      
        xml_reader :id, :from => "MessageID", :as => Integer
        xml_reader :document_transaction_id, :from => "DocumentTransactionID", :in => "ProcessingReport", :as => Integer
        xml_reader :status_code, :in => "ProcessingReport"
        xml_reader :processing_summary, :as => ProcessingSummary, :in => "ProcessingReport"
        xml_reader :results, :as => [Result], :in => "ProcessingReport"
      end
    end
    
    class GetFeedSubmissionResultResponse
      xml_name "AmazonEnvelope"

      xml_reader :header, :as => Header
      # flattened header
      xml_reader :document_version, :as => Float, :in => "Header"
      xml_reader :merchant_id, :from => "MerchantIdentifier", :in => "Header"
      
      xml_reader :message_type
      xml_reader :message, :as => Message
    end
    
  end
end

