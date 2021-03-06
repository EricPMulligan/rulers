# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rulers/version'

Gem::Specification.new do |spec|
  spec.name          = 'rulers'
  spec.version       = Rulers::VERSION
  spec.authors       = ['Eric Mulligan']
  spec.email         = ['eric.pierre.mulligan@gmail.com']

  spec.summary       = %q{A Rack-based Web Framework}
  spec.description   = %q{A Rack-based Web Framework,}
  spec.homepage      = 'http://localhost:5000'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 11.3'
  spec.add_development_dependency 'rspec', '~> 3.5'

  spec.add_runtime_dependency 'rack', '~> 2.0'
  spec.add_runtime_dependency 'erubis', '~> 2.7'
  spec.add_runtime_dependency 'multi_json', '~> 1.12'
  spec.add_runtime_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'test-unit', '~> 3.2'
end
