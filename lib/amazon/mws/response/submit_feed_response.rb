module Amazon
  module MWS

    class SubmitFeedResponse < Response
      xml_name "SubmitFeedResponse"
      result = "SubmitFeedResult"

      xml_reader :feed_submission, :as => FeedSubmission, :in => result
      xml_reader :request_id, :in => "ResponseMetadata"
    end
    
  end
end