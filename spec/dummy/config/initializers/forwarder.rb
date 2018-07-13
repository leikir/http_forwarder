HttpForwarder::Forwarder.configure do |config|
  config.forward[:dogs] = 'http://doggos.woof'
  config.routes << { controller: :dogs, action: :create, to: 'http://doggy.woof' }
  config.routes << { controller: :dogs, action: :update, to: 'http://doggos.woof' }
  config.routes << { controller: :cats, to: 'http://cats.org' }
  config.forward(:cats).on(:index).to('http://cats.org')
end
