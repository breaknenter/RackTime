require 'rack'
require_relative 'time_app'

use Rack::Reloader, 0

run TimeApp.new
