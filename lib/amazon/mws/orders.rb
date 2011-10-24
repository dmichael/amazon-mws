module Amazon
  module MWS
    module Orders
			
			def get_orders_list(params ={})
        
				created_after = params[:created_after]
        created_before = params[:created_before]
				last_updated_after = params[:last_updated_after]
        last_updated_before = params[:last_updated_before]
				buyer_email = params[:buyer_email]
        seller_order_id = params[:seller_order_id]
				results_per_page = params[:results_per_page]
        fulfillment_channel = params[:fulfillment_channel]
				order_status = params[:order_status]
				marketplace_id = params[:marketplace_id]

      
        query_params = {
          "Action"   => "ListOrders"
        }
      
        query_params.merge!({"CreatedAfter" => created_after}) if created_after
        query_params.merge!({"CreatedBefore" => created_before}) if created_before
				query_params.merge!({"LastUpdatedAfter" =>last_updated_after}) if last_updated_after
        query_params.merge!({"LastUpdatedBefore" => last_updated_before}) if last_updated_before
				query_params.merge!({"BuyerEmail" => buyer_email}) if buyer_email
				query_params.merge!({"SellerOrderId" => seller_order_id}) if seller_order_id
        query_params.merge!({"MaxResultsPerPage" => results_per_page}) if results_per_page
				
				if fulfillment_channel
					i = 1
					fulfillment_channel.to_a.each{|channel| query_params.merge!({"FulfillmentChannel.Channel.#{i}" => channel}); i += 1 }
				end
	 			
				if order_status
					i = 1
					order_status.to_a.each{|status| query_params.merge!({"OrderStatus.Status.#{i}" => status}); i += 1 }	
				end
				
				if marketplace_id
					i = 1
					marketplace_id.to_a.each{|id| query_params.merge!({"MarketplaceId.Id.#{i}" => id}); i += 1 }
				end
            
        response = post("/Orders/#{Authentication::VERSION}", query_params)
        #RequestOrdersResponse.format(response)
      end
			
      def get_orders_list_by_next_token(params ={})
        next_token = params[:next_token]
        
        query_params = {
          "Action"   => "ListOrdersByNextToken"
        }
      	if next_token
		      query_params.merge!({"NextToken" => next_token}) 
				end
				response = post("/Orders/#{Authentication::VERSION}", query_params)
      end
      
			def get_list_order_items(params ={})
        amazon_order_id = params[:amazon_order_id]
        
        query_params = {
          "Action"   => "ListOrderItems"
        }
      	if amazon_order_id
		      query_params.merge!({"AmazonOrderId" => amazon_order_id}) 
				end
				response = post("/Orders/#{Authentication::VERSION}", query_params)
      end

			def get_orders(params ={})
        amazon_order_id = params[:amazon_order_id]
        
        query_params = {
          "Action"   => "GetOrder"
        }

      	if amazon_order_id
					i = 1
					amazon_order_id.to_a.each{|id| query_params.merge!({"AmazonOrderId.Id.#{i}" => id}); i += 1 } 
				end
				
				response = post("/Orders/#{Authentication::VERSION}", query_params)
      end

    end
  end
end
