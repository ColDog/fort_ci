require "test_helper"

describe FortCI::PipelineStageJob do
  it "can be performed" do
    pipeline = FortCI::Pipeline.create(
        project: user.projects.first,
        variables: {name: 'testing'},
        definition: 'FortCI::Pipelines::StandardDefinition',
        stage: nil,
        status: 'PENDING',
        event: {project_id: user.projects.first.id},
    )

    job = FortCI::PipelineStageJob.new(pipeline_id: pipeline.id)
    job.perform
    job.on_success
  end
end
