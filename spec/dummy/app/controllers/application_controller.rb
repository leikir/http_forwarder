class ApplicationController < ActionController::Base
  include HttpForwarder::ForwarderController
end
