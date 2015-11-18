module EStore
  module Api
    class Product < Grape::API

      resources :product do
        desc 'Get All Products'
        get do
          products = EStore::Product.all
          present products
        end

        route_param :product_id do
          desc 'Get Product Info'
          get do
            product = EStore::Product.get(params[:product_id])
            if product
              present product
            else
              error! "无法找到产品: #{params[:product_id]}", 404
            end
          end
        end
      end

    end
  end
end