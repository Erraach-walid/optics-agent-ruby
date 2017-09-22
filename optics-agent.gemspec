Gem::Specification.new do |s|
  s.name        = 'optics-agent'
  s.version     = '0.5.5'
  s.summary     = "An Agent for Apollo Optics"
  s.description = "An Agent for Apollo Optics, http://optics.apollodata.com"
  s.authors     = ["Meteor Development Group"]
  s.email       = 'vendor+optics@meteor.com'
  s.files       = Dir["{lib}/**/*", "LICENSE", "README.md"]
  s.test_files  = Dir["{spec}/**/*"]

  s.homepage    =
    'http://rubygems.org/gems/optics-agent'
  s.license     = 'MIT'

  s.add_runtime_dependency 'graphql', '~> 1.1'
  s.add_runtime_dependency 'google-protobuf', '~> 3.2'
  s.add_runtime_dependency 'faraday', '~> 0.9.0', '< 0.12'
  s.add_runtime_dependency 'net-http-persistent', '~> 2.0'
  s.add_runtime_dependency 'hitimes', '~> 1.2'

  s.add_development_dependency 'rake', '~> 12'
  s.add_development_dependency 'rspec', '~> 3.5'
end
