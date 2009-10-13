module Amazon
  module MWS
    
    class Inventory < API
      def submit_feed
        AWS::MWS::Base.post("/?Action=SubmitFeed&FeedType=", body = ni)
      end
    end
        
  end
end