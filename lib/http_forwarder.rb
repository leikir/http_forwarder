require 'http_forwarder/version'
require 'http_forwarder/forwarder'
require 'http_forwarder/exceptions/no_route_exception'

module HttpForwarder
  class Engine < Rails::Engine
    ActionController::Base.send :include, HttpForwarder::Forwarder
  end

  HttpForwarder::Forwarder.configure do |config|
    config.routes = []
  end
end
