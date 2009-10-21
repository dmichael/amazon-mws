module Amazon
  module MWS
    
    class ReportRequest < Response
      xml_name "ReportRequestInfo"

      xml_reader :id, :from => "ReportRequestId", :as => Integer
      xml_reader :report_type
      xml_reader :start_date, :as => Time
      xml_reader :end_date, :as => Time
      xml_reader :scheduled?
      xml_reader :submitted_date, :as => Time
      xml_reader :report_processing_status
      #xml_reader :started_processing_date, :as => Time
      #xml_reader :completed_processing_date, :as => Time
    end
    
  end
end