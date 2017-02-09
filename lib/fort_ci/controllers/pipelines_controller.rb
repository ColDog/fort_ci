require "sinatra/extension"
require "fort_ci/serializers/pipeline_serializer"

module FortCI
  module PipelinesController
    extend Sinatra::Extension

    before("/pipelines/?*") { protected! }

    get "/pipelines/?" do
      render json: PipelineSerializer.collection(current_entity.pipelines), root: :pipelines
    end

    get "/pipelines/:id/?" do
      render json: PipelineSerializer.new(current_entity.pipelines.with_pk!(params[:id])), root: :pipeline
    end
  end
end
