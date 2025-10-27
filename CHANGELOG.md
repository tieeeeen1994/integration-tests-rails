# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-10-27

### Added
- Initial release
- Istanbul instrumentation for JavaScript files
- Capybara/Cuprite integration
- RSpec hooks for automatic coverage collection
- HTML, LCOV, and Cobertura report generation
- Automatic file backup and restoration
- Configurable paths for source, output, and coverage directories

### Features
- Zero-config setup with sensible defaults
- Automatic detection and instrumentation of all JavaScript files
- Per-test coverage snapshots
- Merged coverage reports including files with 0% coverage
- Console coverage summary (similar to SimpleCov)
