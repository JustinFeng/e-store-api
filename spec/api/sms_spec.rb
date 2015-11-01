require_relative '../spec_helper'
require './lib/api'

describe EStore::Api::SMS do

  include Rack::Test::Methods

  def app
    EStore::API
  end

  describe 'POST /api/sms' do
    before do
      EStore::SMS.all.destroy
      allow_any_instance_of(Object).to receive(:rand).and_return(123)
    end

    context 'valid phone number' do
      let(:phone_number) { {phone: '13891438527'} }

      it 'responds 204' do
        post '/api/sms', phone_number

        expect(last_response.status).to eq(204)
      end

      it 'saves sms detail' do
        post '/api/sms', phone_number

        sms = EStore::SMS.first(phone: '13891438527')

        expect(sms.phone).to eq '13891438527'
        expect(sms.client_ip).to eq '127.0.0.1'
        expect(sms.code).to eq '000123'
      end
    end

    context 'invalid phone number' do
      let(:phone_number) { {phone: 'abc'} }

      it 'responds 400' do
        post '/api/sms', phone_number

        expect(last_response.status).to eq(400)
      end
    end

  end

end