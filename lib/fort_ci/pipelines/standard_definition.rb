require "fort_ci/pipelines/definition"
require "fort_ci/pipelines/builders/basic"

module FortCI
  module Pipelines
    class StandardDefinition < Definition
      include Builders::Basic

      stage :first, description: 'Start 1 Basic Job', jobs: 1
      register

      def first
        job = basic_job_from_file
        if job
          create_job(job)
        end
      end

    end
  end
end
