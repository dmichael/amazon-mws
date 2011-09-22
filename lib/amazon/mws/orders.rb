module Amazon
  module MWS
    
    class Orders
      def request_order_list(list_type, params ={})
        raise InvalidReportType if !REPORT_TYPES.include?(report_type)
        # These may need to be processed
        start_date = params[:start_date]
        end_date   = params[:end_date]
        created_before_date = params[:created_before]
        created_after_date = params[:created_after]
        last_updated_before_date = params[:last_updated_before]
        last_updated_after_date = params[:last_udated_after]
        order_status = params[:order_status]
        
        query_params = {
          "Action"   => "ListOrders"
        }
      
        query_params.merge!({"StartDate" => start_date}) if start_date
        query_params.merge!({"EndDate" => end_date}) if end_date
        query_params.merge!({"CreatedBefore" => created_before_date}) if created_before_date
        query_params.merge!({"CreatedAfter" => created_after_date}) if created_after_date
        query_params.merge!({"LastUpdatedBefore" => last_updated_before_date}) if last_updated_before_date
        query_params.merge!({"LastUpdatedAfter" => last_updated_after_date}) if last_updated_after_date
        query_params.merge!({"OrderStatus" => order_status}) if order_status

        response = get("/Orders/", query_params)
        
        RequestReportResponse.format(response)
      end
    end    
  end
end
