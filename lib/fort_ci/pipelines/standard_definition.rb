require "fort_ci/pipelines/definition"
require "fort_ci/pipelines/builders/basic"

module FortCI
  module Pipelines
    class StandardDefinition < Definition
      include Builders::Basic

      stage :first, description: 'Start 1 Basic Job', jobs: 1
      register

      def first
        create_job(basic_job_from_file)
      end

    end
  end
end
