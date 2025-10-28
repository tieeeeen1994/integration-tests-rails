# frozen_string_literal: true

require_relative 'lib/integration_tests_rails/version'

Gem::Specification.new do |spec|
  spec.name        = 'integration-tests-rails'
  spec.version     = IntegrationTestsRails::VERSION
  spec.authors     = ['Tien']
  spec.email       = ['tieeeeen1994@gmail.com']
  spec.homepage    = 'https://github.com/tieeeeen1994/integration-tests-rails'
  spec.summary     = 'Integration Testing for Rails applications using ' \
                     'Istanbul, Cuprite, Capybara and RSpec specifically.'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.required_ruby_version = '>= 3.4.0'

  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'README.md']

  # Runtime dependencies
  spec.add_dependency 'capybara'
  spec.add_dependency 'cuprite'
  spec.add_dependency 'rails'
  spec.add_dependency 'rspec-rails'
  spec.add_dependency 'webmock'
end
