# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/localizer/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid-localizer"
  spec.version       = Mongoid::Localizer::VERSION
  spec.authors       = ["Josef Šimánek"]
  spec.email         = ["retro@ballgag.cz"]
  spec.description   = %q{Globalize inspired Mongoid localized behaviour}
  spec.summary       = %q{"Globalize" for Mongoid}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mongoid", "> 3.0"
  spec.add_dependency "i18n"

  spec.add_development_dependency "bundler", "> 1.0"
  spec.add_development_dependency "rspec", "~> 2.13.0"
  spec.add_development_dependency "rake"
end
