HttpForwarder::Forwarder.configure do |config|
  config.routes << { controller: :dummy, action: :index, to: 'http://another-dummy.org' }
  config.routes << { controller: :cats, to: 'http://another-cats.org' }
end