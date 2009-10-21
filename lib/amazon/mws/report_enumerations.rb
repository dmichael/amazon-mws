class Amazon::MWS::Report

    module Enumerations
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
    end
    
end