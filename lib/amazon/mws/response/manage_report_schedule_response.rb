module Amazon
  module MWS
    
    class ManageReportScheduleResponse < Response
      xml_name "ManageReportScheduleResponse"
      result = "ManageReportScheduleResult"

      xml_reader :count, :in =>  result, :as => Integer
      xml_reader :request_id, :in => "ResponseMetadata"      
      xml_reader :report_schedule, :in => result, :as => ReportSchedule
    end
    
  end
end