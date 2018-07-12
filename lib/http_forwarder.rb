require 'http_forwarder/version'
require 'http_forwarder/forwarder'

module HttpForwarder
  class Engine < Rails::Engine
    ActionController::Base.send :include, HttpForwarder::Forwarder
  end
end
