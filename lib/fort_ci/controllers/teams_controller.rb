require "sinatra/extension"
require "fort_ci/serializers/team_serializer"
require "fort_ci/serializers/user_serializer"

module FortCI
  module TeamsController
    extend Sinatra::Extension

    before("/teams/?*") { protected! }

    get "/teams/?" do
      render json: TeamSerializer.collection(current_user.teams), root: :teams
    end

    get "/teams/:id/?" do
      render json: TeamSerializer.new(current_user.find_team!(params[:id])), root: :team
    end

    get "/teams/:id/users/?" do
      render json: UserSerializer.collection(current_user.find_team!(params[:id]).users), root: :users
    end
  end
end
