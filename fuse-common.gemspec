lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'fuse_common/version'

Gem::Specification.new do |spec|
  spec.name = 'fuse-common'
  spec.version = FuseCommon::VERSION
  spec.authors = ['Ivan Garmatenko']
  spec.email = %w[igarmatenko@sphereinc.com]
  spec.homepage = 'https://github.com/Fuseit/fuse-common'

  spec.summary = spec.description = "
    Gem contains integrations, common code without business logic, etc.
    which used by Fuse monolith and it's microservices
  "

  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = 'https://github.com'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f =~ /^\.(.*)/
    f.match %r{^(test|spec|features)/}
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  # After updating Airbrake make sure that fuse_common/airbrake_libraries.rb is relevant
  spec.add_dependency 'airbrake', '~> 9.2.2'
  spec.add_dependency 'figaro', '~> 1.1'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rails', '~> 4.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.3'
  spec.add_development_dependency 'rubocop-junit-formatter', '~> 0.1'
end
