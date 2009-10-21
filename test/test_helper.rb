require 'test/unit'
#require 'benchmark'
require File.join(File.dirname(__FILE__), '..', 'lib', 'amazon', 'mws')

def xml_for(name)
  Pathname.new(File.dirname(__FILE__)).expand_path.dirname.join("examples/xml/#{name}.xml")
end