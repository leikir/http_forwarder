require 'http_forwarder/version'
require 'http_forwarder/forwarder'
require 'http_forwarder/router_configurator'

module HttpForwarder
  HttpForwarder::Forwarder.configure do |config|
    config.router = RouterConfigurator.new
  end
end
