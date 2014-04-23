module Amazon
  module MWS

    module Report

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
          :flat_file_fba_orders       => '_GET_AMAZON_FULFILLED_SHIPMENTS_DATA_',
          :converged_flat_file_order_report => '_GET_CONVERGED_FLAT_FILE_ORDER_REPORT_DATA_',
          :payment_settlement_report => '_GET_FLAT_FILE_PAYMENT_SETTLEMENT_DATA_',
          :alternative_payment_settlement_report => '_GET_ALT_FLAT_FILE_PAYMENT_SETTLEMENT_DATA_',
          :payment_settlement_xml_report => '_GET_PAYMENT_SETTLEMENT_DATA_'
        }
      
        SCHEDULE = {
          '15 minutes' =>	'_15_MINUTES_',
          '30 minutes' =>	'_30_MINUTES_',
          '1 hour'	   => '_1_HOUR_',
          '2 hours'	   => '_2_HOURS_',
          '4 hours'	   => '_4_HOURS_',
          '8 hours'	   => '_8_HOURS_',
          '12 hours'   => '_12_HOURS_',
          '1 day'	     => '_1_DAY_',
          '2 days'     =>	'_2_DAYS_',
          '3 days'     =>	'_72_HOURS_',
          '7 days'     =>	'_7_DAYS_',
          '14 days'	   => '_14_DAYS_',
          '15 days'	   => '_15_DAYS_',
          '30 days'	   => '_30_DAYS_',
          'Delete'     =>	'_NEVER_'
        }
      end
    
    end
  end    
end
