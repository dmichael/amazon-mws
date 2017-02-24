require 'mocha'
require File.join(File.dirname(__FILE__), 'test_helper')

class QueryStringTest < Test::Unit::TestCase

  def setup
    @params = {
      :access_key => 'denied',
      :marketplace_id => 'Amazon\'s marketplace id',
      :merchant_id => 'AFAKEMERCHANTID',
      :verb => :get,
      :secret_access_key => 'do you know how to keep a secret?',
      :server => 'mws.amz.co.uk'
    }

    AWS::MWS::Authentication::Signature.stubs(:new).returns('a signature')

  end

  def test_expected_string
    qs = Amazon::MWS::Authentication::QueryString.new(@params).downcase
    assert_kind_of(String, qs)

    expected_keys = ['AWSAccessKeyId', 'Marketplace', 'Merchant',
                     'SignatureMethod', 'SignatureVersion', 'Timestamp',
                     'Version', 'Signature']

    expected_keys.each do |key|
      actual = qs.include? key.downcase
      assert_equal(true, actual)
    end

  end

end
