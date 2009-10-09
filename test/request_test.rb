require File.join(File.dirname(__FILE__), 'test_helper')
require 'yaml'

class RequestTest < Test::Unit::TestCase
  def setup
    config = YAML.load_file( File.join(File.dirname(__FILE__), '../lib/amazon/mws.yml') )
    puts config.inspect
    
    Amazon::MWS::Base.establish_connection!(
      config['production']
    )
  end
  
  def test_first
    #http = Net::HTTP.new("mws.amazon.com", 80)
    Amazon::MWS::Base.get("/")
  end

end