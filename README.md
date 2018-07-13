# About HttpForwarder
![Build Status](https://circleci.com/gh/leikir/http_forwarder.svg?style=shield)

HttpForwarder is a gem that lets you easily forward a request from your app to 
a specified target. It also enables you to transform the request before doing so. 
For example, it is very handy when it comes to service communications in a microservices architecture.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_forwarder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_forwarder

To use it you'll also need to add the [http](https://github.com/httprb/http) gem for the gem to work: 

```ruby
gem 'http'
```

## Usage

### Setup

Once you installed the gem, you have to include it in the controller you want to use it in:

```ruby
  include HttpForwarder::Forwarder
```

Then you need to set up your routes in a new file `config/initializers/forwarder.rb` like 
this:

```ruby
HttpForwarder::Forwarder.configure do |config|
  config.router.forward(:dogs).on(:create).to('http://doggy.woof')
  config.router.forward(:dogs).on(:index).to('http://doggos.woof')
  config.router.forward(:cats).to('http://kittykitty.miaw')
end
```
The argument of the method `forward()`is your controller name, the argument of the method `on()` is your method name and the argument of the method `to()` is the target you want to forward to. For example, in the example above, the method `create` of the dogs controller redirects the request to `http://doggy.woof`.
It is mandatory to specify the controller and the target, whereas if you don't specify the action it will assume that all your controller methods redirect to the same url. In the example above, all the cats controller actions will redirect to `http://kittykitty.miaw`. 

### Forwarding without modification

If you want to forward the request and render the response without any modification whatsoever, simply user the `forward_and_render` method:

```ruby
def index
  forward_and_render
end
```

If you want to manipulate the response, simply use the `forward` method :

```ruby 
def update
  response = forward
  parsed_response = JSON.parse(response.body)
  parsed_response['data']['name'] = 'droopy'
  render json: parsed_response, status: response.status
end 
```

### Modifying the request before forwarding

Sometimes you might want to change the arriving request before forwarding it. To do so, you can pass a proc to our forward method to make the changes you want :

```ruby
class DogsController < ApplicationController

  include HttpForwarder::Forwarder

  def initialize
    super
    set_up_procs
  end

  def create
    response = forward do |body|
      @update_dog_name.call(body)
    end
    render_response(response_from_other_api)
  end

  private

  def set_up_procs
    @update_dog_name = Proc.new do |body|
      body = JSON.parse(body)
      body['data']['name'] = 'rex'
      @body = body.to_json
    end
  end
end
```

In the example above we update the `body`, but it is also possible to change the `path` of the request or the `headers`.
<strong> Be careful though ! </strong> The variable you want to modify must contains <stong> @ </stong> before affecting the value.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leikir/http_forwarder.
