require "fort_ci/serializers/base_serializer"

module FortCI
  class RunnerJobSerializer < BaseSerializer
    attributes :id, :pipeline_id, :status, :commit, :branch, :runner, :spec
  end
end
