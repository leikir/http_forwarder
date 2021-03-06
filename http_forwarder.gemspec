
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'http_forwarder/version'

Gem::Specification.new do |spec|
  spec.name          = 'http_forwarder'
  spec.version       = HttpForwarder::VERSION
  spec.authors       = ['alexis delahaye', 'amine dhobb', 'sami ben-yahia']
  spec.email         = ['alexis.delahaye@leikir.io', 'amine.dhobb@leikir.io', 'contact@leikir.io']

  spec.summary       = 'A gem that simply adds a forward mechanism to a Rails controller,\
                         with possible modification of the request.'
  spec.description   = 'HttpForwarder is a gem that lets you easily forward a request from your app\
                       to a specified target.\
                      It also enables you to transform the request before doing so.\
                      Very handy when it comes to service communications in a microservices architecture.'
  spec.homepage      = 'https://github.com/leikir/http_forwarder'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_dependency 'actionpack'
  spec.add_dependency 'http'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'
end
