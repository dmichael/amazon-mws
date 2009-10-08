module Amazon
  module MWS
    module VERSION #:nodoc:
      MAJOR    = '0'
      MINOR    = '0'
      TINY     = '1' 
      BETA     = Time.now.to_i.to_s
    end
    
    Version = [VERSION::MAJOR, VERSION::MINOR, VERSION::TINY, VERSION::BETA].compact * '.'
  end
end
