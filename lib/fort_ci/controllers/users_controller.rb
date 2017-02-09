require "sinatra/extension"
require "fort_ci/serializers/user_serializer"

module FortCI
  module UsersController
    extend Sinatra::Extension

    before("/users/?*") { protected! }

    get "/users/current/?" do
      render json: UserSerializer.new(current_user), root: :user
    end

    get "/users/auth_token/?" do
      render json: {jwt: auth_token_for(current_user)}
    end
  end
end
