require_relative '../spec_helper'
require './lib/api'

describe EStore::Api::User do

  include Rack::Test::Methods

  def app
    EStore::API
  end

  describe 'POST /api/user' do
    before do
      EStore::User.all.destroy
    end

    context 'valid credential' do
      let(:credentials) { {phone: '13891438527', password: '123456'} }

      it 'responds 201' do
        post '/api/user', credentials

        expect(last_response.status).to eq(201)
      end

      it 'returns user info' do
        post '/api/user', credentials

        user = EStore::User.first(phone: '13891438527')
        user_info = JSON.parse(last_response.body)

        expect(user_info['phone']).to eq '13891438527'
        expect(user_info['api_key']).to eq user.api_key
      end
    end

    context 'invalid credential' do
      let(:credentials) { {phone: 'abc', password: '123456'} }

      it 'responds 400' do
        post '/api/user', credentials

        expect(last_response.status).to eq(400)
      end
    end

  end

  describe 'POST /api/sign_in' do

    before(:all) do
      EStore::User.create({phone: '13891438527', encrypted_password: '123456'})
    end

    context 'valid credential' do
      let(:credentials) { {phone: '13891438527', password: '123456'} }

      it 'returns user info' do
        post '/api/sign_in', credentials

        user = EStore::User.first(phone: '13891438527')
        user_info = JSON.parse(last_response.body)

        expect(last_response.status).to eq(200)
        expect(user_info['phone']).to eq '13891438527'
        expect(user_info['api_key']).to eq user.api_key
      end
    end

    context 'invalid credential' do
      let(:credentials) { {phone: '13891438527', password: 'abcdef'} }

      it 'responds 401' do
        post '/api/sign_in', credentials

        expect(last_response.status).to eq(401)
      end
    end

  end

  describe 'PUT /api/user/:user_id' do

    let(:phone) { '13891438527' }
    let(:api_key) { 'valid_key' }
    let(:password) { '123456' }
    let(:new_password) { 'abcdef' }

    before do
      EStore::User.all.destroy
      EStore::User.create({
                              phone: '13891438527',
                              encrypted_password: '123456',
                              api_key: 'valid_key'})
      header 'Api-Key', api_key
    end

    context 'valid api key' do

      it 'changes password' do
        put "/api/user/#{phone}", {password: password, new_password: new_password}

        user = JSON.parse(last_response.body)
        expect(last_response.status).to eq(200)
        expect(user['api_key']).to eq api_key
        expect(user['phone']).to eq(phone)

        post '/api/sign_in', {phone: phone, password: new_password}

        expect(last_response.status).to eq(200)
      end

      context 'invalid old password' do
        let(:password) { '234567' }

        it 'does not change password' do
          put "/api/user/#{phone}", {password: password, new_password: new_password}

          post '/api/sign_in', {phone: phone, password: '123456'}

          expect(last_response.status).to eq(200)
        end
      end

      context 'invalid phone number' do

        let(:phone) { '15555555555' }

        it 'does not change password' do
          put "/api/user/#{phone}", {password: password, new_password: new_password}

          post '/api/sign_in', {phone: '13891438527', password: password}

          expect(last_response.status).to eq(200)
        end

      end

    end

    context 'invalid api key' do
      let(:api_key) { 'invalid_key' }

      it 'does not change password' do
        put "/api/user/#{phone}", {password: password, new_password: new_password}

        post '/api/sign_in', {phone: phone, password: password}

        expect(last_response.status).to eq(200)
      end
    end

  end

end