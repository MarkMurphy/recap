# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'recap/version'

Gem::Specification.new do |gem|
  gem.name        = "recap"
  gem.version     = Recap::VERSION
  gem.authors     = ["Tom Ward"]
  gem.email       = ["tom@popdog.net"]
  gem.homepage    = "http://gofreerange.com/recap"
  gem.summary     = %q{GIT based deployment recipes for Capistrano}
  gem.description = %q{GIT based deployment recipes for Capistrano}

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_dependency 'capistrano', '~>3.2.1'
  gem.add_dependency 'thor'
  gem.add_dependency 'open4'
  gem.add_dependency 'rake', '~>10.3.1'
  gem.add_dependency 'i18n'
  gem.add_development_dependency 'fl-rocco', '~>1.0.0'
  gem.add_development_dependency 'rspec', '~>2.14.1'
  gem.add_development_dependency 'mocha', '~>1.1.0'
  gem.add_development_dependency 'cucumber', '~>1.3.15'
  gem.add_development_dependency 'faker', '~>1.3.0'
end
