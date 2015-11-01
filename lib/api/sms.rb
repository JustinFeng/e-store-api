require 'httparty'

module EStore
  module Api
    class SMS < Grape::API

      helpers do
        def same_client_ip_within_60_seconds
          EStore::SMS.count(:client_ip => request.ip, :created_at.gt => Time.now - 60.seconds) > 0
        end

        def same_phone_number_within_60_seconds
          EStore::SMS.count(:phone => params[:phone], :created_at.gt => Time.now - 60.seconds) > 0
        end

        def generate_code
          rand(1000000).to_s.rjust(6, '0')
        end
      end

      resources :sms do
        desc 'Send SMS'
        params do
          requires :phone, type: String, desc: 'Phone number', regexp: /^1\d{10}$/
        end
        post do
          if same_client_ip_within_60_seconds or same_phone_number_within_60_seconds
            error! '验证短信发送过于频繁，请稍后再试', 400
          else
            code = generate_code
            response = HTTParty.post('http://yunpian.com/v1/sms/send.json',
                                     body: {
                                         apikey: 'API_KEY',
                                         mobile: params[:phone],
                                         text: "【猫爪网】您的验证码是#{code}。如非本人操作，请忽略本短信"})
            if (JSON.parse(response.body)["code"] == 0)
              EStore::SMS.create(client_ip: request.ip, phone: params[:phone], code: code)
              body false
            else
              error! '验证短信发送失败，请稍后再试'
            end
          end
        end
      end

    end
  end
end