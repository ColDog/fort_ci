require "sinatra/extension"
require "fort_ci/serializers/job_serializer"

module FortCI
  module JobsController
    extend Sinatra::Extension

    before("/jobs/?*") { protected! }

    get "/jobs/?" do
      results = current_entity.jobs
                    .query(params)
                    .limit(params[:limit] || 10)
                    .offset(params[:offset])

      render json: JobSerializer.collection(results), root: :jobs
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
