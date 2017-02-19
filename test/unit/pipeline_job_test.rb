require "test_helper"

class ErroringPipeline < FortCI::Pipelines::Definition
  stage :first, description: 'Job With Error', jobs: 1
  register

  def self.triggered_by?(event)
    event.name == 'errorjobtest'
  end

  def first
    raise("Error!!!")
  end
end

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

  it "does not pass an erroring test" do
    pipeline = FortCI::Pipeline.create(
        project: user.projects.first,
        variables: {name: 'testing'},
        definition: 'ErroringPipeline',
        stage: nil,
        status: 'PENDING',
        event: {project_id: user.projects.first.id},
    )

    job = FortCI::Worker::WorkerJob.create(
        job_class: 'FortCI::PipelineStageJob',
        handler: JSON.generate({pipeline_id: pipeline.id}),
        attempts: 0,
    )

    FortCI::Worker.executor.run_job(job)

    refute_nil job.last_error
    assert_equal 'ERROR', pipeline.reload.status

    FortCI::Worker.executor.run_job(job)

    refute_nil job.last_error
    assert_equal 'ERROR', pipeline.reload.status
  end

end
