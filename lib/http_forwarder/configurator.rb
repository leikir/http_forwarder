module HttpForwarder
  def self.init_config
    Forwarder.configure do |config|
      config.router = RouterConfigurator.new
      config.headers = HeadersConfigurator.new
    end
  end
end
