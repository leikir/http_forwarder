HttpForwarder::Forwarder.configure do |config|
  config.routes << { controller: :dogs, action: :index, to: 'http://doggos.woof' }
  config.routes << { controller: :dogs, action: :create, to: 'http://doggy.woof' }
  config.routes << { controller: :dogs, action: :update, to: 'http://doggos.woof' }
  config.routes << { controller: :cats, to: 'http://cats.org' }
end
