require "fort_ci/serializers/base_serializer"

module FortCI
  class PipelineSerializer < BaseSerializer
    attributes :id, :project_id, :definition_class, :variables, :stage, :status, :error, :event
  end
end
