# frozen_string_literal: true

module IntegrationTestsRails
  # Railtie to integrate with Rails applications.
  class Railtie < Rails::Railtie
    # rubocop:disable Metrics/BlockLength
    rake_tasks do
      namespace :integration_tests_rails do
        desc 'Set up integration tests environment.'
        task install: :environment do
          unless system('which yarn > /dev/null 2>&1')
            puts 'Yarn is not installed. Please install Yarn first: https://yarnpkg.com/getting-started/install'
            exit 1
          end

          puts 'Installing Istanbul...'
          system('yarn add --dev istanbul-lib-instrument istanbul-lib-coverage istanbul-lib-report istanbul-reports')
          system('yarn install')

          puts 'Updating .gitignore...'
          gitignore_path = '.gitignore'
          lines_to_add = ['node_modules/', 'coverage/', 'tmp/instrumented_js/', 'tmp/js_backup/']

          if File.exist?(gitignore_path)
            content = File.read(gitignore_path)
            lines_to_add.each do |line|
              if content.include?(line)
                puts "'#{line}' already exists in .gitignore."
              else
                File.open(gitignore_path, 'a') { |file| file.puts line }
                puts "Added '#{line}' to .gitignore."
              end
            end
          else
            puts '.gitignore does not exist. Skipping.'
          end

          puts 'Integration tests environment setup complete.'
        end

        namespace :istanbul do
          desc 'Remove Istanbul installation.'
          task uninstall: :environment do
            puts 'Removing Istanbul...'
            system('yarn remove istanbul-lib-instrument istanbul-lib-coverage istanbul-lib-report istanbul-reports')
            puts 'Istanbul removed. '

            if File.exist?('.gitignore')
              content = File.read('.gitignore')
              new_content = content.dup
              lines_to_remove = ['tmp/instrumented_js/', 'tmp/js_backup/']
              lines_to_remove.each do |line|
                if content.include?(line)
                  new_content = new_content.gsub("#{line}\n", '')
                  puts "Removed '#{line}' from .gitignore."
                else
                  puts "'#{line}' not found in .gitignore. Skipping."
                end
              end
              if new_content == content
                puts 'No changes made to .gitignore.'
              else
                File.write('.gitignore', new_content)
                puts '.gitignore updated.'
              end
            end
          end
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
