require "sinatra/extension"
require "fort_ci/serializers/user_serializer"

module FortCI
  module UsersController
    extend Sinatra::Extension

    before("/users/?*") { protected! }

    get "/users/current/?" do
      render json: UserSerializer.new(current_user), root: :user
    end
  end
end
