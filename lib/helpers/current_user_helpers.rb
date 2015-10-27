module EStore
  module CurrentUserHelpers
    def current_user
      user = EStore::User.first(api_key: headers['Api-Key'])
      if user
        if (params[:user_id].nil? || user.phone == params[:user_id]) &&
            (params[:password].nil? || user.encrypted_password == params[:password])
          return user
        else
          error!({error: 'authorization failed'}, 403)
        end
      else
        error!({error: 'authentication failed'}, 401)
      end
    end
  end
end
