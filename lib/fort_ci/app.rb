require "sinatra/base"

require "omniauth"
require "omniauth-github"

require "fort_ci/config"

require "fort_ci/controllers"

require "fort_ci/helpers/render_helper"
require "fort_ci/helpers/auth_helper"
require "fort_ci/helpers/serialization_helper"

module FortCI
  class App < Sinatra::Base
    include SerializationHelper

    use Rack::Session::Cookie, secret: FortCI.config.secret
    use OmniAuth::Builder do
      provider(
        :github,
        FortCI.config.github_credentials[:key],
        FortCI.config.github_credentials[:secret],
        scope: FortCI.config.github_credentials[:scope],
      )
    end

    before { FortCI.logger.info("#{request.request_method} #{request.path} params=#{params} user=#{current_user} runner=#{current_runner} entity=#{current_entity}") }

    register AuthController
    register UsersController
    register TeamsController
    register ProjectsController
    register RunnerController
    register PipelinesController
    register PipelineDefinitionsController
    register JobsController
    register EventsController

    helpers RenderHelper
    helpers AuthHelper

    before { env['PATH_INFO'].sub!(/^\/api\//, '/') }
    before { body_parser }

    get "/" do
      render json: {name: "FortCI", version: FortCI::VERSION}
    end

  end
end
