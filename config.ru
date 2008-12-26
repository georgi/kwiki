require 'kwiki'

Dir.chdir(File.dirname(__FILE__))

use Rack::Reloader

run KWiki.new
