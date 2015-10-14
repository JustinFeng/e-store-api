ENV['RACK_ENV'] = ENV['CI'] ? 'ci' : 'test'

require './boot'

DataMapper.auto_migrate!