module EStore
  class User
    include DataMapper::Resource

    property :phone, String, required: true, :format => /^1\d{10}$/, length: 11, key: true
    property :encrypted_password, BCryptHash, required: true

    property :api_key, APIKey

    property :created_at, DateTime

    class Entity < Grape::Entity
      expose :phone, :api_key, :created_at
    end
  end
end