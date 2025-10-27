# Istanbul Cuprite Rails

[![Gem Version](https://badge.fury.io/rb/istanbul-cuprite-rails.svg)](https://badge.fury.io/rb/istanbul-cuprite-rails)

JavaScript code coverage for Rails applications using Istanbul, Capybara, and Cuprite.

## Features

- ✅ **Istanbul Coverage** - Industry-standard JavaScript code coverage
- ✅ **Seamless Integration** - Works with Rails importmap and asset pipeline
- ✅ **Cuprite Driver** - Fast, headless Chrome testing with Ferrum
- ✅ **RSpec Ready** - Built-in RSpec integration
- ✅ **Zero Config** - Sensible defaults, works out of the box
- ✅ **Test Engine** - Provides routes, controller, and views for testing
- ✅ **Coverage Reports** - HTML, LCOV, and Cobertura formats

## Requirements

- Ruby >= 3.4.0
- Rails >= 7.0
- Node.js and Yarn
- RSpec >= 5.0

## Installation

Add to your Gemfile:

```ruby
group :test do
  gem 'istanbul-cuprite-rails'
end
```

Run the installer:

```bash
bundle install
rails generate istanbul_cuprite_rails:install
```

This will:
- ✅ Install required Node.js packages (Istanbul libraries)
- ✅ Create an initializer with configuration options
- ✅ Show setup instructions

## Setup

### 1. Mount the Engine

Add to `config/routes.rb`:

```ruby
if Rails.env.test?
  mount IstanbulCupriteRails::Engine => '/istanbul_tests'
end
```

### 2. Require in Test Helper

Add to `spec/rails_helper.rb` or `spec/spec_helper.rb`:

```ruby
require 'istanbul_cuprite_rails/setup'
```

That's it! Everything is configured automatically.

### 3. Configure Test Imports (Optional)

If you have JavaScript libraries that need to be exposed globally for testing, configure them in `config/initializers/istanbul_cuprite_rails.rb`:

```ruby
IstanbulCupriteRails.configure do |config|
  config.test_imports = [
    'libs/words_to_datetime',
    'libs/custom_library'
  ]
end
```

## Usage

### Writing Tests

Use the provided shared context in your feature specs:

```ruby
require 'rails_helper'

RSpec.describe 'JavaScript MyLibrary', type: :feature do
  include_context :with_javascript_library_environment

  context 'when calling myFunction' do
    let(:script) { 'MyLibrary.myFunction()' }

    it 'returns expected result' do
      expect(result).to eq('expected value')
    end
  end
end
```

### Running Tests

```bash
bundle exec rspec spec/features/javascript/
```

### Viewing Coverage

Open the HTML report:

```bash
open coverage/javascript/index.html
```

## Configuration

Edit `config/initializers/istanbul_cuprite_rails.rb`:

```ruby
IstanbulCupriteRails.configure do |config|
  # Directory containing JavaScript files to instrument
  config.source_dir = 'app/javascript'

  # Directory for coverage output
  config.coverage_dir = 'coverage/nyc'

  # JavaScript libraries to expose globally in test environment
  config.test_imports = []

  # Capybara wait time
  config.wait_time = 10

  # Files or patterns to exclude from coverage
  config.exclude_patterns = []
end
```

## How It Works

1. **Instrumentation**: Before test suite runs, all JavaScript files are instrumented with Istanbul
2. **File Replacement**: Instrumented files temporarily replace originals (works with importmap)
3. **Coverage Collection**: After each test, coverage data is collected from `window.__coverage__`
4. **Snapshot Storage**: Each test's coverage is saved as a separate JSON file
5. **Report Generation**: At exit, all snapshots are merged using Istanbul's native merge
6. **Cleanup**: Original files are restored automatically

## Advanced Usage

### Multiple Script Execution

Execute multiple scripts in sequence:

```ruby
let(:script) do
  [
    'window.myVar = 123;',
    'MyLibrary.init();',
    'MyLibrary.getValue()' # This result is returned
  ]
end
```

### Custom Test Page

Override the test view by creating:

```
app/views/istanbul_cuprite_rails/tests/index.html.erb
```

## Troubleshooting

### Coverage is 0%

- Ensure JavaScript files are in `app/javascript/`
- Check that tests are actually executing JavaScript
- Verify the test page loads correctly

### Files Not Restored

If tests are interrupted, manually restore files:

```bash
rm -rf app/javascript
cp -r tmp/js_backup app/javascript
```

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

MIT License. See [MIT-LICENSE](MIT-LICENSE) for details.
