require File.join(File.dirname(__FILE__), 'test_helper')

class SignatureTest < Test::Unit::TestCase
  def setup
    @expected_base64 = "F8zvW31wDYENPZrwkVYaPOLHh2R+goZncb0SlwTwyes="
    @expected_digest = "\027\314\357[}p\r\201\r=\232\360\221V\032<\342\307\207d~\202\206gq\275\022\227\004\360\311\353"
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