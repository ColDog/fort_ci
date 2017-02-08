require "sinatra/extension"
require "fort_ci/serializers/user_serializer"
require "fort_ci/serializers/team_serializer"

module FortCI
  module UsersController
    extend Sinatra::Extension

    before("/users/?*") { protected! }
    before("/teams/?*") { protected! }

    get "/users/current/?" do
      render json: UserSerializer.new(current_user), root: :user
    end

    get "/teams/?" do
      render json: TeamSerializer.collection(current_user.teams), root: :teams
    end
  end
end
