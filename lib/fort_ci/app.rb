require "sinatra/base"

require "omniauth"
require "omniauth-github"

require "fort_ci/config"

require "fort_ci/controllers"

require "fort_ci/helpers/render_helper"
require "fort_ci/helpers/auth_helper"

module FortCI
  class App < Sinatra::Base

    use Rack::Session::Cookie, secret: FortCI.config.secret
    use OmniAuth::Builder do
      provider(
        :github,
        FortCI.config.github_credentials[:key],
        FortCI.config.github_credentials[:secret],
        scope: FortCI.config.github_credentials[:scope],
      )
    end

    register AuthController
    register UsersController
    register TeamsController
    register ProjectsController

    helpers RenderHelper
    helpers AuthHelper

    before { env['PATH_INFO'].sub!(/^\/api\//, '/') }

    get "/" do
      render json: {name: "FortCI", version: FortCI::VERSION}
    end

  end
end
