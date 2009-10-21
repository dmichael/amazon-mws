module Amazon
  module MWS

    class GetFeedSubmissionListByNextTokenResponse < Response
      xml_name "GetFeedSubmissionListByNextTokenResponse"
      result = "GetFeedSubmissionListByNextTokenResult"

      xml_reader :has_next?, :in => result
      xml_reader :next_token, :in => result
      xml_reader :feed_submissions, :as => [FeedSubmission], :in => result
      xml_reader :request_id, :in => "ResponseMetadata"
    end
    
  end
end
