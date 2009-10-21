module Amazon
  module MWS
    
    class ReportInfo < Response
      xml_name "ReportInfo"
      
      xml_reader :id, :from => "ReportId", :as => Integer
      xml_reader :type, :from => "ReportType"
      xml_reader :report_request_id, :as => Integer
      xml_reader :available_date, :as => Time
      xml_reader :acknowledged?
      xml_reader :acknowledged_date, :as => Time
    end
    
  end
end