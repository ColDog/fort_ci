require "sinatra/extension"
require "fort_ci/serializers/pipeline_definition_serializer"

module FortCI
  module PipelineDefinitionsController
    extend Sinatra::Extension

    before("/pipeline_definitions/?*") { protected! }

    get "/pipeline_definitions/?" do
      render json: PipelineDefinitionSerializer.collection(FortCI.pipeline_definitions), root: :pipeline_definitions
    end

    get "/pipeline_definitions/:name/?" do
      render json: PipelineDefinitionSerializer.new(FortCI.pipeline_definitions[params[:name]]), root: :pipeline_definition
    end

    post "/pipeline_definitions/?" do
      # save and reload
      render json: PipelineDefinitionSerializer.new(FortCI.pipeline_definitions[params[:name]]), root: :pipeline_definition
    end
  end
end
