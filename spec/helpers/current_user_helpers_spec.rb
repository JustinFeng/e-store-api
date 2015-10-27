require_relative '../spec_helper'
require './lib/helpers/current_user_helpers'

describe EStore::CurrentUserHelpers do

  include Rack::Test::Methods

  def app
    TestAPI
  end

  let(:api_key) { 'valid_key' }
  let(:user_id) { '13891438527' }
  let(:password) { '123456' }

  let(:request_params) { {user_id: user_id, password: password} }

  before do
    EStore::User.all.destroy
    EStore::User.create({phone: '13891438527', encrypted_password: '123456', api_key: 'valid_key'})
    header 'Api-Key', api_key
  end

  context 'with valid api key' do
    context 'no phone nor password' do
      let(:user_id) { nil }
      let(:password) { nil }

      it 'responds ok' do
        post '/', request_params

        user = JSON.parse(last_response.body)
        expect(last_response.status).to eq(201)
        expect(user['phone']).to eq('13891438527')
      end
    end

    context 'with phone but no password' do
      let(:password) { nil }

      context 'valid phone' do
        let(:user_id) { '13891438527' }

        it 'responds ok' do
          post '/', request_params

          user = JSON.parse(last_response.body)
          expect(last_response.status).to eq(201)
          expect(user['phone']).to eq('13891438527')
        end
      end

      context 'invalid phone' do
        let(:user_id) { '15555555555' }

        it 'responds 403' do
          post '/', request_params

          expect(last_response.status).to eq(403)
        end
      end
    end

    context 'with password but no phone' do
      let(:user_id) { nil }

      context 'valid password' do
        let(:password) { '123456' }

        it 'responds ok' do
          post '/', request_params

          user = JSON.parse(last_response.body)
          expect(last_response.status).to eq(201)
          expect(user['phone']).to eq('13891438527')
        end
      end

      context 'invalid password' do
        let(:password) { 'abcdef' }

        it 'responds 403' do
          post '/', request_params

          expect(last_response.status).to eq(403)
        end
      end
    end

    context 'with both password and phone' do
      let(:user_id) { '13891438527' }
      let(:password) { '123456' }

      context 'valid phone and password' do
        it 'responds ok' do
          post '/', request_params

          user = JSON.parse(last_response.body)
          expect(last_response.status).to eq(201)
          expect(user['phone']).to eq('13891438527')
        end
      end

      context 'invalid phone' do
        let(:user_id) { '15555555555' }

        it 'responds 403' do
          post '/', request_params

          expect(last_response.status).to eq(403)
        end
      end

      context 'invalid password' do
        let(:password) { 'abcdef' }

        it 'responds 403' do
          post '/', request_params

          expect(last_response.status).to eq(403)
        end
      end
    end
  end

  context 'with invalid api key' do
    let(:api_key) { 'invalid_key' }

    it 'responds 401' do
      post '/', request_params

      expect(last_response.status).to eq(401)
    end
  end

end

class TestAPI < Grape::API
  format :json

  helpers EStore::CurrentUserHelpers

  post do
    present current_user
  end
end