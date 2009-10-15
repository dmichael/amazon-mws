require 'rubygems'
require 'cgi'
require 'uri'
require 'openssl'
require 'net/https'
require 'time'
require 'date'
require 'hmac'
require 'hmac-sha2'
require 'base64'
require 'builder'
require "rexml/document"

$:.unshift(File.dirname(__FILE__))
require 'mws/lib/extensions'
require_library_or_gem 'builder' unless defined? Builder
require_library_or_gem 'mime/types', 'mime-types' unless defined? MIME::Types

require 'mws/lib/memoizable'
require 'mws/api'
require 'mws/api/feeds'
require 'mws/api/reports'
require 'mws/base'
require 'mws/version'
require 'mws/exceptions'
require 'mws/connection'
require 'mws/connection/management'
require 'mws/connection/request_builder'
require 'mws/authentication'
require 'mws/authentication/query_string'
require 'mws/authentication/signature'

require 'mws/feed_builder'

# This may be overkill
Amazon::MWS::Base.class_eval do
  include Amazon::MWS::Connection::Management
end

Amazon::MWS::API.class_eval do
  extend Amazon::MWS::API::Feeds
  extend Amazon::MWS::API::Reports
end

AWS = Amazon

require_library_or_gem 'xmlsimple', 'xml-simple' unless defined? XmlSimple
=begin
# If libxml is installed, we use the FasterXmlSimple library, that provides most of the functionality of XmlSimple
# except it uses the xml/libxml library for xml parsing (rather than REXML). If libxml isn't installed, we just fall back on
# XmlSimple.
AWS::S3::Parsing.parser =
  begin
    require_library_or_gem 'xml/libxml'
    # Older version of libxml aren't stable (bus error when requesting attributes that don't exist) so we
    # have to use a version greater than '0.3.8.2'.
    raise LoadError unless XML::Parser::VERSION > '0.3.8.2'
    $:.push(File.join(File.dirname(__FILE__), '..', '..', 'support', 'faster-xml-simple', 'lib'))
    require_library_or_gem 'faster_xml_simple' 
    FasterXmlSimple
  rescue LoadError
    XmlSimple
  end
=end