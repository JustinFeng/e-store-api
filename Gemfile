# source 'http://ruby.taobao.org'
source 'http://rubygems.org'

ruby '2.4.1'

gem 'grape'
gem 'grape-entity'
gem 'rack-cors', require: 'rack/cors'
gem 'data_mapper'
gem 'dm-postgres-adapter'
gem 'rake'
gem 'httparty'
gem 'grape-swagger'

group :development, :test do
  gem 'byebug'
end

group :test, :ci do
  gem 'rack-test'
  gem 'rspec'
end