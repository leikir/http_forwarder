HttpForwarder::Forwarder.configure do |config|
  config.router.forward(:dogs).on(:create).to('http://doggy.woof')
  config.router.forward(:dogs).on(:update).to('http://doggos.woof')
  config.router.forward(:dogs).on(:index).to('http://doggos.woof')
  config.router.forward(:cats).to('http://kittykitty.miaw')
end
