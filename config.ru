require 'rack'
require './time_app'

use Rack::Reloader, 0

run TimeApp.new
