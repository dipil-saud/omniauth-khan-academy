# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-khan-academy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dipil"]
  gem.email         = ["dipil.saud@gmail.com"]
  gem.description   = %q{A KhanAcademy OAuth strategy for OmniAuth 1.0}
  gem.summary       = %q{A KhanAcademy OAuth strategy for OmniAuth 1.0}
  gem.homepage      = "https://github.com/dipil-saud/omniauth-khan-academy"

  gem.add_runtime_dependency 'omniauth', '~> 1.0'
  gem.add_runtime_dependency 'oauth'
  gem.add_runtime_dependency 'multi_json'
  gem.add_runtime_dependency 'activesupport'

  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'pry'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "omniauth-khan-academy"
  gem.require_paths = ["lib"]
  gem.version       = Omniauth::KhanAcademy::VERSION
end
