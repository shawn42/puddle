# -*- encoding: utf-8 -*-
require File.expand_path('../lib/puddle/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Shawn Anderson"]
  gem.email         = ["shawn42@gmail.com"]
  gem.description   = %q{Add object pooling to any class.}
  gem.summary       = %q{Easily add object pooling to any class.}
  gem.homepage      = %q{https://github.com/shawn42/puddle}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "puddle"
  gem.require_paths = ["lib"]
  gem.version       = Puddle::VERSION

  gem.add_development_dependency "rspec-core"
  gem.add_development_dependency "rspec-mocks"
  gem.add_development_dependency "rspec-expectations"
  gem.add_development_dependency "mocha"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
end
