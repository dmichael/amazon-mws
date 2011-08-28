require File.join(File.dirname(__FILE__), 'test_helper')

class AuthenticationTest < Test::Unit::TestCase

  def setup
    @params = {
      :access_key => 'denied',
      :marketplace_id => 'Amazon\'s marketplace id',
      :merchant_id => 'AFAKEMERCHANTID',
      :verb => :get,
      :secret_access_key => 'do you know how to keep a secret?',
      :server => 'mws.amz.co.uk'
    }
  end
  
  def test_querystring_data
    qs = Amazon::MWS::Authentication::QueryString.new(@params).downcase
    expected_keys = ['AWSAccessKeyId', 'Marketplace', 'Merchant',
                     'SignatureMethod', 'SignatureVersion', 'Timestamp',
                     'Version', 'Signature']

    expected_keys.each do |key|
      actual = qs.include? key.downcase
      assert_equal(true, actual)
    end
  end

end
