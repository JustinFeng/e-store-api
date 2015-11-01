require_relative '../spec_helper'
require './lib/api'

describe EStore::Api::SMS do

  include Rack::Test::Methods

  def app
    EStore::API
  end

  describe 'POST /api/sms' do
    let(:response_code) { 0 }

    before do
      EStore::SMS.all.destroy
      allow_any_instance_of(Object).to receive(:rand).and_return(123)
      allow(HTTParty).to receive(:post).and_return(double('Response', body: "{\"code\": #{response_code}}"))
    end

    context 'valid phone number' do
      let(:request_data) { {phone: '13891438527'} }

      it 'responds 204' do
        post '/api/sms', request_data

        expect(last_response.status).to eq(204)
      end

      it 'saves sms detail' do
        post '/api/sms', request_data

        sms = EStore::SMS.first(phone: '13891438527')

        expect(sms.phone).to eq '13891438527'
        expect(sms.client_ip).to eq '127.0.0.1'
        expect(sms.code).to eq '000123'
      end

      xit 'sends sms' do
        expect(HTTParty).to receive(:post).with('http://yunpian.com/v1/sms/send.json',
                                                body: hash_including(mobile: '13891438527'))

        post '/api/sms', request_data
      end

      xcontext 'sms service failed' do
        let(:response_code) { 1 }

        it 'responds 500' do
          post '/api/sms', request_data

          expect(last_response.status).to eq(500)
          expect(JSON.parse(last_response.body)['error']).to eq('验证短信发送失败，请稍后再试')
        end
      end

      context 'request from same client ip twice' do
        before do
          EStore::SMS.create({client_ip: '127.0.0.1', phone: '13888888888', code: '123456', created_at: previous_sms_time})
        end

        context 'within 60 seconds' do
          let(:previous_sms_time) { Time.now }

          it 'responds 400' do
            post '/api/sms', request_data

            expect(last_response.status).to eq(400)
            expect(JSON.parse(last_response.body)['error']).to eq('验证短信发送过于频繁，请稍后再试')
          end
        end

        context 'after 60 seconds' do
          let(:previous_sms_time) { Time.now - 61.seconds }

          it 'responds 204' do
            post '/api/sms', request_data

            expect(last_response.status).to eq(204)
          end
        end
      end

      context 'request to same target phone number twice' do
        before do
          EStore::SMS.create({client_ip: '8.8.8.8', phone: '13891438527', code: '123456', created_at: previous_sms_time})
        end

        context 'within 60 seconds' do
          let(:previous_sms_time) { Time.now }

          it 'responds 400' do
            post '/api/sms', request_data

            expect(last_response.status).to eq(400)
            expect(JSON.parse(last_response.body)['error']).to eq('验证短信发送过于频繁，请稍后再试')
          end
        end

        context 'after 60 seconds' do
          let(:previous_sms_time) { Time.now - 61.seconds }

          it 'responds 204' do
            post '/api/sms', request_data

            expect(last_response.status).to eq(204)
          end
        end
      end
    end

    context 'invalid phone number' do
      let(:request_data) { {phone: 'abc'} }

      it 'responds 400' do
        post '/api/sms', request_data

        expect(last_response.status).to eq(400)
      end
    end

  end

end