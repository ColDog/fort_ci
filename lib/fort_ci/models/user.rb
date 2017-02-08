require "fort_ci/db"
require "sequel"

module FortCI
  class User < Sequel::Model

    def self.from_omniauth(auth)
      new_user = false
      user = User.find(provider: auth.provider, provider_id: auth.uid)
      unless user
        user = create(provider: auth.provider, provider_id: auth.uid)
        new_user = true
      end

      user.username = auth.info.nickname
      user.email = auth.info.email
      user.name = auth.info.name
      user.token = auth.credentials.token
      user.refresh_token = auth.credentials.refresh_token
      user.save

      user.sync if new_user

      user
    end

    def sync
    end

  end
end
