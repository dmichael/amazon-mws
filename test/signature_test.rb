require File.join(File.dirname(__FILE__), 'test_helper')

class SignatureTest < Test::Unit::TestCase
  def setup
    @expected_base64 = "+wztLqGgNpnzKExEa4dRUwyJy2r1rfPKHzXdbrLgcVE="
    @expected_digest = "\xFB\f\xED.\xA1\xA06\x99\xF3(LDk\x87QS\f\x89\xCBj\xF5\xAD\xF3\xCA\x1F5\xDDn\xB2\xE0qQ"
  end
  
  def test_sign_with_string_keys
    signature = Amazon::MWS::Authentication::Signature.new(
      {"devil" => "666"}, 
      {:verb => :get, :secret_access_key => "beelzebub"}
    )
    
    # Not sure if this really helps, just locks it down
    assert_equal(@expected_base64, signature)
    assert_equal(@expected_digest, Base64.decode64(signature))
  end
  
  def test_sign_with_symbol_keys
    signature = Amazon::MWS::Authentication::Signature.new(
      {:devil => "666"}, 
      {:verb => :get, :secret_access_key => "beelzebub"}
    )
    
    # Not sure if this really helps, just locks it down
    assert_equal(@expected_base64, signature)
    assert_equal(@expected_digest, Base64.decode64(signature))
  end
end
