module HttpForwarder
  module Exception
    class NoRouteException < StandardError
      def message 
        'No routes specified for HttpForwarder::Forwarder'
      end
    end
  end
end