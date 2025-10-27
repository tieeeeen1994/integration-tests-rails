require_relative 'lib/istanbul_cuprite_rails/version'

Gem::Specification.new do |spec|
  spec.name        = 'istanbul-cuprite-rails'
  spec.version     = IstanbulCupriteRails::VERSION
  spec.authors     = ['Tien']
  spec.email       = ['tieeeeen1994@gmail.com']
  spec.homepage    = 'https://github.com/tieeeeen1994/istanbul-cuprite-rails'
  spec.summary     = 'JavaScript coverage for Rails with Istanbul, Capybara, and Cuprite'
  spec.description = 'Provides Istanbul code coverage for JavaScript in Rails applications using Capybara system tests with Cuprite driver'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.required_ruby_version = '>= 3.0.0'

  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'README.md']

  # Runtime dependencies
  spec.add_dependency 'capybara'
  spec.add_dependency 'cuprite'
  spec.add_dependency 'rails'
  spec.add_dependency 'rspec-rails'
end
