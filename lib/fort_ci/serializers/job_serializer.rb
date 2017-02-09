require "fort_ci/serializers/base_serializer"
require "fort_ci/serializers/runner_job_serializer"

module FortCI
  class JobSerializer < BaseSerializer
    attributes :id, :project_id, :pipeline_id, :status, :commit, :branch, :runner

    def project_id
      object.project.id
    end

    def spec
      RunnerJobSerializer.new(object).serializable_hash
    end

    def attributes
      unless @in_collection
        return self.class.attributes + [:spec]
      end
      self.class.attributes
    end
  end
end
