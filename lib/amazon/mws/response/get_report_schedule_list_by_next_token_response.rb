module Amazon
  module MWS

    class GetReportScheduleListByNextTokenResponse < Response
      xml_name "GetReportScheduleListByNextTokenResponse"
      result = "GetReportScheduleListByNextTokenResult"

      xml_reader :has_next?,  :in => result
      xml_reader :next_token, :in => result
      xml_reader :report_schedules, :as => [ReportSchedule], :in => result
      xml_reader :request_id, :in => "ResponseMetadata"
    end
    
  end
end
