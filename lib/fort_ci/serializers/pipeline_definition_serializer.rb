require "fort_ci/serializers/base_serializer"

module FortCI
  class PipelineDefinitionSerializer < BaseSerializer
    attributes :name, :stages, :ensure_stages
  end
end
