require_relative '../spec_helper'
require './lib/api'

describe EStore::Api::Product do

  include Rack::Test::Methods

  def app
    EStore::API
  end

  describe 'GET /api/product/:product_id' do
    before(:all) do
      EStore::Product.all.destroy
      EStore::Product.create({id: 1,
                              name: 'Test Product',
                              description: 'Good Product',
                              price: 100})
    end

    context 'valid product id' do
      let(:product_id) { 1 }

      it 'responds 200' do
        get "/api/product/#{product_id}"

        expect(last_response.status).to eq(200)
      end

      it 'returns product info' do
        get "/api/product/#{product_id}"

        product_info = JSON.parse(last_response.body)

        expect(product_info['id']).to eq 1
        expect(product_info['name']).to eq 'Test Product'
        expect(product_info['description']).to eq 'Good Product'
        expect(product_info['price']).to eq 100
      end
    end

    context 'invalid product id' do
      let(:product_id) { 2 }

      it 'responds 404' do
        get "/api/product/#{product_id}"

        expect(last_response.status).to eq(404)
        expect(JSON.parse(last_response.body)['error']).to eq('无法找到产品: 2')
      end
    end

  end

  describe 'GET /api/product' do
    before(:all) do
      EStore::Product.all.destroy
      EStore::Product.create({id: 1,
                              name: 'Test Product 1',
                              description: 'Good Product',
                              price: 100})
      EStore::Product.create({id: 2,
                              name: 'Test Product 2',
                              description: 'Very Good Product',
                              price: 200})
    end


    it 'responds 200' do
      get '/api/product'

      expect(last_response.status).to eq(200)
    end

    it 'returns products info' do
      get '/api/product'

      products_info = JSON.parse(last_response.body)

      expect(products_info[0]['id']).to eq 1
      expect(products_info[0]['name']).to eq 'Test Product 1'
      expect(products_info[0]['description']).to eq 'Good Product'
      expect(products_info[0]['price']).to eq 100

      expect(products_info[1]['id']).to eq 2
      expect(products_info[1]['name']).to eq 'Test Product 2'
      expect(products_info[1]['description']).to eq 'Very Good Product'
      expect(products_info[1]['price']).to eq 200
    end

  end

end