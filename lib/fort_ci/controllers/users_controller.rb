require "sinatra/extension"
require "fort_ci/serializers/user"

module FortCI
  module UsersController
    extend Sinatra::Extension

    before("/users/?*") { protected! }
    before("/teams/?*") { protected! }

    get "/users/current/?" do
      render json: UserSerializer.new(current_user)
    end
  end
end
