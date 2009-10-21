module Amazon
  module MWS

    class CancelFeedSubmissionsResponse < Response
      xml_name "CancelFeedSubmissionsResponse"
      result = "CancelFeedSubmissionsResult"

      xml_reader :count, :in => result, :as => Integer
      xml_reader :feed_submissions, :as => [FeedSubmission], :in => result
      xml_reader :request_id, :in => "ResponseMetadata"
    end
    
  end
end