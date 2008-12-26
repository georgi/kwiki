require 'wiki'

Dir.chdir(File.dirname(__FILE__))

use Rack::Reloader

run Wiki.new
