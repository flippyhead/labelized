# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'labelized/version'

Gem::Specification.new do |spec|
  spec.name        = 'labelized'
  spec.version     = Labelized::VERSION
  spec.authors     = ['Peter T. Brown']
  spec.email       = 'peter@pathable.com'
  spec.description = 'A better tag library'
  spec.summary     = 'A better tag library'
  spec.homepage    = 'http://github.com/flippyhead/labelized'
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '>= 3.2.6', '< 5'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'activerecord', '>= 3.2.6', '< 5'
  spec.add_development_dependency 'sqlite3'
end
