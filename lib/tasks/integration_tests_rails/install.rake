# frozen_string_literal: true

namespace :integration_tests_rails do # rubocop:disable Metrics/BlockLength
  desc 'Set up integration tests environment.'
  task :install do
    unless system('which yarn > /dev/null 2>&1')
      puts 'Yarn is not installed. Please install Yarn first: https://yarnpkg.com/getting-started/install'
      exit 1
    end

    puts 'Installing Istanbul...'
    system('yarn add --dev istanbul-lib-instrument istanbul-lib-coverage istanbul-lib-report istanbul-reports')
    system('yarn install')

    puts 'Updating .gitignore...'
    gitignore_path = '.gitignore'
    lines_to_add = ['node_modules/', 'coverage/']

    if File.exist?(gitignore_path)
      content = File.read(gitignore_path)
      lines_to_add.each do |line|
        if content.include?(line)
          puts "'#{line}' already exists in .gitignore."
        else
          File.open(gitignore_path, 'a') { |f| f.puts line }
          puts "Added '#{line}' to .gitignore."
        end
      end
    else
      puts '.gitignore does not exist. Skipping.'
    end

    puts 'Integration tests environment setup complete.'
  end
end
