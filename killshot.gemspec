# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'killshot/version'

Gem::Specification.new do |spec|
  spec.name          = 'killshot'
  spec.version       = Killshot::VERSION
  spec.authors       = ['Steve Jothen']
  spec.email         = ['sjothen@gmail.com']
  spec.description   = %q{Find hotlinks on a given domain}
  spec.summary       = %q{Killshot idenfities any hotlinks on a given domain against a user specified whitelist}
  spec.homepage      = 'https://github.com/sjothen/killshot'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = %w(killshot)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_dependency 'anemone',  '>= 0.7.2'
  spec.add_dependency 'trollop',  '>= 2.0'
  spec.add_dependency 'nokogiri', '>= 1.5.9'
  spec.add_dependency 'colored',  '>= 1.2'
end
