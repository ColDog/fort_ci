require "sinatra/extension"

module FortCI::Controllers
  module Sessions
    extend Sinatra::Extension

    get "/auth/:provider/callback/?" do
      user = User.from_omniauth(request.env['omniauth.auth'])
      session[:user_id] = user.id
      redirect FortCI.config.ui_root_url
    end

    delete "/auth/?" do
      session[:user_id] = nil
    end
  end
end
