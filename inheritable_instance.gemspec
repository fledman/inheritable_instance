# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'inheritable_instance/version'

Gem::Specification.new do |spec|
  spec.name          = "inheritable_instance"
  spec.version       = InheritableInstance::VERSION
  spec.authors       = ["David Feldman"]
  spec.email         = ["dbfeldman@gmail.com"]

  spec.summary       = "Allow descendants to inherit instance variables"
  spec.description   = "Useful for persisting class-level configuration to subclasses"
  spec.homepage      = "https://github.com/fledman/inheritable_instance"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
