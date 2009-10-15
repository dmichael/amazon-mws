class Amazon::MWS::API
  module Reports
    #https://mws.amazon.com/docs/devGuide/index.html?ReportType.html
    REPORT_TYPES = {
      :flat_file_open_listings    => '_GET_FLAT_FILE_OPEN_LISTINGS_DATA_',
      :merchant_listing           => '_GET_MERCHANT_LISTINGS_DATA_',
      :merchant_listings_lite     => '_GET_MERCHANT_LISTINGS_DATA_LITE_',
      :merchant_listings_liter    => '_GET_MERCHANT_LISTINGS_DATA_LITER_',
      :merchant_canceled_listings => '_GET_MERCHANT_CANCELLED_LISTINGS_DATA_',
      :nemo_merchant_listings     => '_GET_NEMO_MERCHANT_LISTINGS_DATA_',
      :afn_inventory              => '_GET_AFN_INVENTORY_DATA_',
      :flat_file_actionable_order => '_GET_FLAT_FILE_ACTIONABLE_ORDER_DATA_',
      :orders                     => '_GET_ORDERS_DATA_', #API Function: ManageReportSchedule
      :flat_file_order_report     => '_GET_FLAT_FILE_ORDER_REPORT_DATA_', #API Function: ManageReportSchedule
      :flat_file_orders           => '_GET_FLAT_FILE_ORDERS_DATA_',
      :converged_flat_file_order_report => '_GET_CONVERGED_FLAT_FILE_ORDER_REPORT_DATA_'
    }
    
    def request_report(report_type, params ={})
      raise InvalidReportType if !REPORT_TYPES.include?(report_type)
      # These may need to be processed
      start_date = params[:start_date]
      end_date   = params[:end_date]
      
      query_params = {
        "Action"   => "RequestReport", 
        "ReportType" => REPORT_TYPES[report_type]
      }
      
      query_params = query_params.merge({"StartDate" => start_date}) if start_date
      query_params = query_params.merge({"EndDate" => end_date}) if end_date
            
      response = Amazon::MWS::Base.get("/", query_params)
    end
    
    def get_report_request_list(params = {})
      response = Amazon::MWS::Base.get("/", {"Action" => "GetReportRequestList"})
    end
    
    def get_report_request_count(params = {})
      response = Amazon::MWS::Base.get("/", {"Action" => "GetReportRequestCount"})
    end
    
    def get_report(report_id, params = {})
      response = Amazon::MWS::Base.get("/", {"Action" => "GetReport", "ReportId" => report_id})
    end
    
    def get_report_count(params = {})
      response = Amazon::MWS::Base.get("/", {"Action" => "GetReportCount"})
    end
    
    def get_report_list(params = {})
      response = Amazon::MWS::Base.get("/", {"Action" => "GetReportList"})
    end
  end
  
end