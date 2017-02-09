require "fort_ci/serializers/base_serializer"

module FortCI
  class JobSerializer < BaseSerializer
    attributes :id, :pipeline_id, :status, :commit, :branch, :worker, :spec
  end
end
