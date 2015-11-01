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
      end

      resources :sms do
        desc 'Send SMS'
        params do
          requires :phone, type: String, desc: 'Phone number', regexp: /^1\d{10}$/
        end
        post do
          if same_client_ip_within_60_seconds or same_phone_number_within_60_seconds
            error! '短信发送过于频繁，请稍后再试', 400
          else
            EStore::SMS.create(client_ip: request.ip, phone: params[:phone])
            body false
          end
        end
      end

    end
  end
end