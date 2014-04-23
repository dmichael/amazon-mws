module Amazon
  module MWS
    
    class OrdersRequest < Response
      #xml_reader :id, :from => "AmazonOrderId"
      #xml_reader :purchase_date, :as => Time
      #xml_reader :last_update_date, :as => Time
      #xml_reader :amount, :in => :order_total, :as => Float
      #xml_reader :number_of_items_shipped, :as => Integer
      #xml_reader :number_of_items_unshipped, :as => Integer
    end 
  end
end

