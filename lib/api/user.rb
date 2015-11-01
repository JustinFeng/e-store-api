require './lib/helpers/current_user_helpers'

module EStore
  module Api
    class User < Grape::API

      helpers EStore::CurrentUserHelpers

      resources :user do
        desc 'Sign up'
        params do
          requires :phone, type: String, desc: 'Phone number', regexp: /^1\d{10}$/
          requires :password, type: String, desc: 'User password', allow_blank: false
          requires :code, type: String, desc: 'Verification code', regexp: /^\d{6}$/
        end
        post do
          sms = EStore::SMS.last(phone: params[:phone])
          if sms && sms.code == params[:code]
            user = EStore::User.create(phone: params[:phone], encrypted_password: params[:password])
            present user
          else
            error! '验证码错误', 400
          end
        end

        params do
          requires :user_id, type: String, desc: 'Phone number', regexp: /^1\d{10}$/
        end
        route_param :user_id do
          before do
            @user = current_user
          end

          desc 'Change password'
          params do
            requires :password, type: String, allow_blank: false, desc: 'Old user password'
            requires :new_password, type: String, allow_blank: false, desc: 'New user password'
          end
          put do
            @user.update(encrypted_password: params[:new_password])
            present @user
          end
        end
      end

      desc 'Sign in'
      params do
        requires :phone, type: String, desc: 'Phone number', regexp: /^1\d{10}$/
        requires :password, type: String, desc: 'User password', allow_blank: false
      end
      post '/sign_in' do
        user = EStore::User.first(phone: params[:phone])
        if user && user.encrypted_password == params[:password]
          user.update(api_key: DataMapper::Property::APIKey.generate)
          status 200
          present user
        else
          error!({error: 'phone number or password is wrong'}, 401)
        end
      end

    end
  end
end