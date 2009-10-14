module Amazon
  module MWS
    
    # Base API Class
    # is this needed??
    class API
    end
    
    # Intended usage:
    #
    # AWS::MWS::Base.establish_connection!(config['production'])
    #
    #
    # Amazon::MWS::Inventory.submit_feed(:product=>{})
    
    class Inventory < API
      class << self # everything is a static/class method
        
        def submit_feed()
         body     = Amazon::MWS::Feed.new(??)
         response = Amazon::MWS::Base.post("/", {"Action"=>"SubmitFeed", "FeedType"=>"something"}, body)
        end
      
        def get_feed_submission_list
         response = 
         Amazon::MWS::Base.post("/", {
           "Action"   => "GetFeedSubmissionList", 
           "FeedType" => "something"
          })
        end
        
      end
    end
    # Inventory
  end
end


