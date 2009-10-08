require 'test/unit'
require 'net/http'
require File.join(File.dirname(__FILE__), '..', 'lib', 'amazon', 'mws')

class AuthenticationTest < Test::Unit::TestCase
  def setup
    @request = Net::HTTP::Get.new("https://mws.amazonaws.com")
    @access_key_id = "yyy"
    @secret_access_key = "xxx"
    @merchant_id = 0
    @marketplace_id = 0
  end
  
  def test_first
    Amazon::MWS::Authentication::QueryString.new(@request, @access_key_id, @secret_access_key, @merchant_id, @marketplace_id)
  end
end