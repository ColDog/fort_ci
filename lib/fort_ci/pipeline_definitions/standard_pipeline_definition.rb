require "fort_ci/pipeline_definitions/pipeline_helpers/basic_job_helper"

module FortCI
  class StandardPipelineDefinition < FortCI::PipelineDefinition
    include PipelineHelpers::BasicJobHelper
    stage :first, description: 'Start 1 Basic Job', jobs: 1

    def first
      create_default_job(basic_job_from_file)
    end

  end
end

FortCI.register_pipeline_definition FortCI::StandardPipelineDefinition
