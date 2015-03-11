# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ethereum/version'

Gem::Specification.new do |spec|
  spec.name          = "ethereum"
  spec.version       = Ethereum::VERSION
  spec.authors       = ["tomlion"]
  spec.email         = ["qycpublic@gmail.com"]
  spec.summary       = %q{Adapter for Ethereum}
  spec.description   = %q{Adapter for Ethereum}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "digest-sha3", "~> 1.0.2"
  spec.add_dependency "json"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-core"
  spec.add_development_dependency "rspec-expectations"
  spec.add_development_dependency "rspec-mocks"
  spec.add_development_dependency "pry"
end
