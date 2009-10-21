module Amazon
  module MWS
    
    class GetFeedSubmissionCountResponse < Response
      xml_name "GetFeedSubmissionCountResponse"
      result = "GetFeedSubmissionCountResult"

      xml_reader :count, :in => result, :as => Integer
      xml_reader :request_id, :in => "ResponseMetadata"
    end
    
  end
end