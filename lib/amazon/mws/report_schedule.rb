module Amazon
  module MWS
      
    class ReportSchedule < Response
      xml_name "ReportSchedule"

      xml_reader :report_type
      xml_reader :schedule
      xml_reader :scheduled_date, :as => Time
    end
    
  end
end
