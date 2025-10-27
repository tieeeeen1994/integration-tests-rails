require_relative 'lib/istanbul_cuprite_rails/version'

Gem::Specification.new do |spec|
  spec.name        = 'istanbul-cuprite-rails'
  spec.version     = IstanbulCupriteRails::VERSION
  spec.authors     = ['Your Name']
  spec.email       = ['your.email@example.com']
  spec.homepage    = 'https://github.com/yourusername/istanbul-cuprite-rails'
  spec.summary     = 'JavaScript coverage for Rails with Istanbul, Capybara, and Cuprite'
  spec.description = 'Provides Istanbul code coverage for JavaScript in Rails applications using Capybara system tests with Cuprite driver'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.required_ruby_version = '>= 3.0.0'

  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'README.md']

  # Runtime dependencies
  spec.add_dependency 'capybara', '>= 3.0'
  spec.add_dependency 'cuprite', '>= 0.14'
  spec.add_dependency 'rails', '>= 7.0'

  # Development dependencies
  spec.add_development_dependency 'rspec-rails', '>= 5.0'
end
