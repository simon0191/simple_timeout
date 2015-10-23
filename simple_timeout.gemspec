# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simple_timeout/version"

Gem::Specification.new do |spec|
  spec.name          = "simple_timeout"
  spec.version       = SimpleTimeout::VERSION
  spec.authors       = ["Simon Soriano"]
  spec.email         = ["simon0191@gmail.com"]
  spec.summary       = "A simple implementation of timeout"
  spec.description   = "A simple implementation of timeout"
  spec.homepage      = "https://github.com/simon0191/simple_timeout"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
end
