require_relative 'api/user'
require_relative 'api/sms'
require_relative 'api/product'

module EStore
  class API < Grape::API
    format :json
    prefix :api

    before do
      header 'Access-Control-Allow-Origin', '*'
      header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Api-Key'
    end

    mount Api::User
    mount Api::SMS
    mount Api::Product
  end
end