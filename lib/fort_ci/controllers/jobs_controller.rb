require "sinatra/extension"
require "fort_ci/serializers/job_serializer"

module FortCI
  module JobsController
    extend Sinatra::Extension

    before("/projects/?*") { protected! }

    get "/jobs/?" do
      render json: JobSerializer.collection(current_entity.jobs), root: :jobs
    end

    get "/jobs/:id/?" do
      render json: JobSerializer.new(current_entity.jobs.with_pk!(params[:id])), root: :job
    end

    get "/jobs/:id/output/?" do
      render json: current_entity.jobs.with_pk!(params[:id]).output, root: :output
    end

    post "/jobs/:id/cancel/?" do
      current_entity.jobs.with_pk!(params[:id]).cancel
      render json: {ok: true}
    end
  end
end
