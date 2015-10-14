env = (ENV['RACK_ENV'] || :development).to_sym

require 'bundler'
Bundler.require :default, env

Dir["#{File.dirname(__FILE__)}/lib/models/**/*.rb"].each { |f| require f }
DataMapper.finalize
DataMapper::Model.raise_on_save_failure = true
DataMapper::Logger.new($stdout, :debug) if env == :development

db_config = {
    staging: ENV['CLEARDB_DATABASE_URL'],
    development: 'mysql://root:@localhost/e_store_api_development',
    test: 'mysql://root:@localhost/e_store_api_test',
    ci: 'mysql://ubuntu:@localhost/circle_test'
}[env]

DataMapper.setup(:default, db_config)