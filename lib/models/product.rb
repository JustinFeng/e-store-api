module EStore
  class Product
    include DataMapper::Resource

    property :id, Serial

    property :name, String, required: true
    property :description, Text
    property :price, Integer, required: true

    property :created_at, DateTime

    class Entity < Grape::Entity
      expose :id, :name, :description, :price, :created_at
    end
  end
end