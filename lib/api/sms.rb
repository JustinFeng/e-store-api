module EStore
  module Api
    class SMS < Grape::API

      resources :sms do
        desc 'Send SMS'
        params do
          requires :phone, type: String, desc: 'Phone number', regexp: /^1\d{10}$/
        end
        post do
          EStore::SMS.create(phone: params[:phone])
          body false
        end
      end

    end
  end
end