env = (ENV['RACK_ENV'] || :development).to_sym

require 'bundler'
Bundler.require :default, env

Dir["#{File.dirname(__FILE__)}/lib/models/**/*.rb"].each { |f| require f }
DataMapper.finalize
DataMapper::Model.raise_on_save_failure = true
DataMapper::Logger.new($stdout, :debug) if env == :development

db_config = {
    staging: ENV['DATABASE_URL'],
    development: 'postgres://postgres:@localhost/e_store_api_development',
    test: 'postgres://postgres:@localhost/e_store_api_test',
    ci: 'postgres://ubuntu:@localhost/circle_test'
}[env]

DataMapper.setup(:default, db_config)