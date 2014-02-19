# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zonify/version'

Gem::Specification.new do |spec|
  spec.name          = "zonify"
  spec.version       = Zonify::VERSION
  spec.authors       = ["Nikhil Nanjappa", "Ashish Upadhyay", "Ankur Gera", "Gourav Tiwari", "Hrishita Vaish"]
  spec.email         = ["kainikhil@gmail.com", "ashish.upadhyaye@gmail.com", "ankurgera@gmail.com", "gouravtiwari21@gmail.com", "vaish.hrishita@tcs.com"]
  spec.summary       = %q{Finds timezone for a specific time eg. Where is it 8 AM now ?}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "active_support"
end
