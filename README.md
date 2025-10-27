# Istanbul Cuprite Rails# Istanbul Cuprite Rails# Istanbul Cuprite Rails



JavaScript code coverage for Rails applications using Istanbul, Capybara, and Cuprite.



## FeaturesJavaScript code coverage for Rails applications using Istanbul, Capybara, and Cuprite.[![Gem Version](https://badge.fury.io/rb/istanbul-cuprite-rails.svg)](https://badge.fury.io/rb/istanbul-cuprite-rails)



- ✅ **Istanbul instrumentation** for JavaScript files

- ✅ **Automatic Capybara/Cuprite setup** (local or remote Chrome)

- ✅ **RSpec integration** with automatic coverage collection## InstallationJavaScript code coverage for Rails applications using Istanbul, Capybara, and Cuprite.

- ✅ **Multiple report formats** (HTML, LCOV, Cobertura)

- ✅ **Zero-config defaults** with optional customization



## InstallationAdd this line to your application's Gemfile:## Features



Add this line to your application's Gemfile:



```ruby```ruby- ✅ **Istanbul Coverage** - Industry-standard JavaScript code coverage

gem 'istanbul-cuprite-rails', group: :test

```gem 'istanbul-cuprite-rails', group: :test- ✅ **Seamless Integration** - Works with Rails importmap and asset pipeline



Then install:```- ✅ **Cuprite Driver** - Fast, headless Chrome testing with Ferrum



```bash- ✅ **RSpec Ready** - Built-in RSpec integration

bundle install

npm install --save-dev istanbul-lib-instrument istanbul-lib-coverage istanbul-lib-report istanbul-reportsAnd then execute:- ✅ **Zero Config** - Sensible defaults, works out of the box

```

- ✅ **Test Engine** - Provides routes, controller, and views for testing

## Usage

```bash- ✅ **Coverage Reports** - HTML, LCOV, and Cobertura formats

### Quick Start (One-Line Setup)

$ bundle install

In your `spec/support/capybara.rb`:

```## Requirements

```ruby

require 'istanbul_cuprite_rails'



# One-line setup with defaults## Usage- Ruby >= 3.4.0

IstanbulCupriteRails.setup

- Rails >= 7.0

# Or customize

IstanbulCupriteRails.setup(wait_time: 10) do |config|### Basic Setup- Node.js and Yarn

  config.source_dir = 'app/javascript'

  config.coverage_path = 'coverage/nyc'- RSpec >= 5.0

end

```In your `spec/support/capybara.rb` or `spec/rails_helper.rb`:



That's it! The gem automatically:## Installation

- Configures Capybara with Cuprite driver

- Sets up Istanbul instrumentation  ```ruby

- Adds RSpec hooks for coverage collection

- Handles remote/local Chrome detectionrequire 'istanbul_cuprite_rails'Add to your Gemfile:



### Remote Chrome Support



The gem auto-detects remote Chrome via environment variables:# Configure (optional - these are the defaults)```ruby



```bashIstanbulCupriteRails.configure do |config|group :test do

export CAPYBARA_REMOTE=true

export CHROME_URL=http://chrome:3000  config.source_dir = 'app/javascript'           # Where your JS files are  gem 'istanbul-cuprite-rails'

bundle exec rspec spec/features/javascript/

```  config.output_dir = 'tmp/instrumented_js'      # Where instrumented files goend



Or specify explicitly:  config.backup_dir = 'tmp/js_backup'            # Where backups are stored```



```ruby  config.coverage_path = 'coverage/nyc'          # Where coverage data is saved

IstanbulCupriteRails.setup(

  remote: true,endRun the installer:

  chrome_url: 'http://chrome:3000'

)

```

# Enable RSpec integration```bash

### Manual Configuration (Advanced)

IstanbulCupriteRails::RSpecIntegration.configure_rspecbundle install

For more control:

```rails generate istanbul_cuprite_rails:install

```ruby

require 'istanbul_cuprite_rails'```



# Configure Istanbul### Prerequisites

IstanbulCupriteRails.configure do |config|

  config.source_dir = 'app/javascript'This will:

  config.output_dir = 'tmp/instrumented_js'

  config.backup_dir = 'tmp/js_backup'1. **Node.js** and **npm** must be installed- ✅ Install required Node.js packages (Istanbul libraries)

  config.coverage_path = 'coverage/nyc'

end2. Install Istanbul dependencies:- ✅ Create an initializer with configuration options



# Configure Capybara- ✅ Show setup instructions

IstanbulCupriteRails::Capybara::Setup.configure_capybara(

  wait_time: 10,```bash

  remote: false

)npm install --save-dev istanbul-lib-instrument istanbul-lib-coverage istanbul-lib-report istanbul-reports## Setup



# Enable RSpec hooks```

IstanbulCupriteRails::RSpecIntegration.configure_rspec

```### 1. Mount the Engine



## How It Works3. **Cuprite** must be configured as your JavaScript driver:



1. **Before Suite**: Instruments all JavaScript files using IstanbulAdd to `config/routes.rb`:

2. **During Tests**: Collects coverage from `window.__coverage__` after each feature test

3. **After Suite**: Generates HTML/LCOV/Cobertura coverage reports```ruby

4. **Cleanup**: Restores original JavaScript files

require 'capybara/cuprite'```ruby

## Coverage Reports

Capybara.javascript_driver = :cupriteif Rails.env.test?

Reports are generated at:

```  mount IstanbulCupriteRails::Engine => '/istanbul_tests'

- **HTML**: `coverage/javascript/index.html`

- **LCOV**: `coverage/javascript/lcov.info`end

- **Cobertura**: `coverage/javascript/cobertura-coverage.xml`

## How It Works```

Console output shows coverage summary:



```

JavaScript Coverage: 120 / 1987 LOC (6.03%) covered.1. **Before Suite**: Instruments all JavaScript files using Istanbul### 2. Require in Test Helper

Coverage report: coverage/javascript/index.html

```2. **During Tests**: Collects coverage data from `window.__coverage__` after each feature test



## Configuration Options3. **After Suite**: Generates HTML/LCOV/Cobertura coverage reportsAdd to `spec/rails_helper.rb` or `spec/spec_helper.rb`:



| Option | Default | Description |4. **Cleanup**: Restores original JavaScript files

|--------|---------|-------------|

| `source_dir` | `'app/javascript'` | Directory containing your JavaScript files |```ruby

| `output_dir` | `'tmp/instrumented_js'` | Where instrumented files are stored |

| `backup_dir` | `'tmp/js_backup'` | Where original files are backed up |## Coverage Reportsrequire 'istanbul_cuprite_rails/setup'

| `coverage_path` | `'coverage/nyc'` | Where coverage snapshots are saved |

```

## Example Test

After running your tests, coverage reports will be available at:

```ruby

RSpec.describe 'JavaScript Library', type: :feature, js: true doThat's it! Everything is configured automatically.

  it 'executes JavaScript code' do

    visit '/test_page'- HTML: `coverage/javascript/index.html`



    result = page.evaluate_script('MyLibrary.doSomething()')- LCOV: `coverage/javascript/lcov.info`### 3. Configure Test Imports (Optional)



    expect(result).to eq('expected value')- Cobertura: `coverage/javascript/cobertura-coverage.xml`

  end

endIf you have JavaScript libraries that need to be exposed globally for testing, configure them in `config/initializers/istanbul_cuprite_rails.rb`:

```

## Configuration Options

## Troubleshooting

```ruby

### Coverage shows 0%

| Option | Default | Description |IstanbulCupriteRails.configure do |config|

- Ensure tests visit pages that load your JavaScript

- Check `window.__coverage__` exists in browser console|--------|---------|-------------|  config.test_imports = [

- Verify instrumentation succeeded (look for "Instrumentation Complete")

| `source_dir` | `'app/javascript'` | Directory containing your JavaScript files |    'libs/words_to_datetime',

### Files not restored after tests

| `output_dir` | `'tmp/instrumented_js'` | Where instrumented files are temporarily stored |    'libs/custom_library'

The gem auto-restores files via `at_exit` hook. If interrupted:

| `backup_dir` | `'tmp/js_backup'` | Where original files are backed up |  ]

```ruby

IstanbulCupriteRails::Istanbul::Collector.restore_original_files| `coverage_path` | `'coverage/nyc'` | Where coverage snapshots are saved |end

```

```

### Remote Chrome connection issues

## Example Test

- Verify Chrome container is running: `docker ps`

- Check CHROME_URL is correct: `echo $CHROME_URL`## Usage

- Enable logging: `export CAPYBARA_LOG=true`

```ruby

## Docker Setup Example

RSpec.describe 'JavaScript Library', type: :feature, js: true do### Writing Tests

```yaml

# docker-compose.yml  it 'executes JavaScript code' do

services:

  chrome:    visit '/test_page'Use the provided shared context in your feature specs:

    image: browserless/chrome:latest

    ports:

      - "3000:3000"

    environment:    result = page.evaluate_script('MyLibrary.doSomething()')```ruby

      - MAX_CONCURRENT_SESSIONS=10

```    require 'rails_helper'



```bash    expect(result).to eq('expected value')

docker-compose up -d chrome

export CAPYBARA_REMOTE=true  endRSpec.describe 'JavaScript MyLibrary', type: :feature do

export CHROME_URL=http://localhost:3000

bundle exec rspec spec/features/javascript/end  include_context :with_javascript_library_environment

```

```

## License

  context 'when calling myFunction' do

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Troubleshooting    let(:script) { 'MyLibrary.myFunction()' }



### Coverage shows 0%    it 'returns expected result' do

      expect(result).to eq('expected value')

- Ensure your test visits a page that loads your JavaScript    end

- Check that `window.__coverage__` is defined in your browser console  end

- Verify Istanbul instrumentation succeeded (look for "Instrumentation Complete" message)end

```

### Files not restored after tests

### Running Tests

The gem automatically restores files using an `at_exit` hook. If tests are interrupted, you may need to manually restore:

```bash

```rubybundle exec rspec spec/features/javascript/

IstanbulCupriteRails::Istanbul::Collector.restore_original_files```

```

### Viewing Coverage

## License

Open the HTML report:

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

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
