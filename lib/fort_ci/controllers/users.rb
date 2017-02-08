require "sinatra/extension"
require "fort_ci/serializers/user"

module FortCI::Controllers
  module Users
    extend Sinatra::Extension

    before("/users/?*") { protected! }
    before("/teams/?*") { protected! }

    get "/users/current/?" do
      render json: FortCI::Serializers::User.new(current_user)
    end
  end
end
