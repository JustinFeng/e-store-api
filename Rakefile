require 'rspec/core/rake_task'

task default: :specs

desc 'Run all specs'
RSpec::Core::RakeTask.new(:specs) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--color --format d']
end

namespace :db do
  require './boot'

  desc 'destroy all data and recreate database'
  task :create do
    if ENV['RACK_ENV'] == 'production'
      puts 'Not allowed in production'
    else
      DataMapper.auto_migrate!
      puts '=======Database created======='
    end
  end

  desc 'migrate database'
  task :migrate do
    DataMapper.auto_upgrade!
    puts '=======Database migrated======='
  end
end
