require_relative 'api/user'

module EStore
  class API < Grape::API
    format :json
    prefix :api

    mount Api::User
  end
end