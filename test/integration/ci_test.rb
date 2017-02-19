require "test_helper"

class DoubleJobPipeline < FortCI::Pipelines::Definition
  include FortCI::Pipelines::Builders::Basic
  stage :first, description: 'Start 1 Basic Job', jobs: 1
  stage :second, description: 'Start 1 Basic Job', jobs: 1
  register

  def self.triggered_by?(event)
    event.name == 'doublejobtest'
  end

  def first
    create_job(basic_job_from_file)
  end

  def second
    create_job(basic_job_from_file)
  end
end

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

describe FortCI do
  it "can perform and queue jobs" do
    initial = FortCI::Pipeline.count
    post_as_user "/events", {project_id: project.id, name: 'test'}
    assert response.ok?
    assert_equal initial + 1, FortCI::Pipeline.count

    pipeline = FortCI::Pipeline.last

    assert_equal 'PENDING', pipeline.status
  end

  it "can run a pipeline" do
    initial = FortCI::Pipeline.count
    post_as_user "/events", {project_id: project.id, name: 'test'}
    assert response.ok?
    assert_equal initial + 1, FortCI::Pipeline.count

    pipeline = FortCI::Pipeline.last

    assert_equal 'PENDING', pipeline.status
    initial = FortCI::Job.count
    FortCI::Worker.executor.run(1)
    assert_equal initial + 1, FortCI::Job.count
    assert_equal 'PENDING', pipeline.reload.status

    job = pipeline.jobs.first
    job.status = 'COMPLETED'
    job.save

    FortCI::Worker.executor.run(1)
    assert_equal 'SUCCESSFUL', pipeline.reload.status
  end

  it "can run a two job pipeline" do
    initial = FortCI::Pipeline.count
    post_as_user "/events", {project_id: project.id, name: 'doublejobtest'}
    assert response.ok?
    assert_equal initial + 2, FortCI::Pipeline.count

    pipeline = FortCI::Pipeline.find(definition: 'DoubleJobPipeline')
    refute_nil pipeline

    assert_equal 'PENDING', pipeline.status

    initial = FortCI::Job.count
    FortCI::Worker.executor.run(1)
    assert_equal initial + 2, FortCI::Job.count
    assert_equal 'PENDING', pipeline.reload.status

    job = pipeline.jobs.last
    job.status = 'COMPLETED'
    job.save

    FortCI::Worker.executor.run(1)
    assert_equal 'PENDING', pipeline.reload.status

    job = pipeline.jobs.last
    job.status = 'COMPLETED'
    job.save

    FortCI::Worker.executor.run(1)
    assert_equal 'SUCCESSFUL', pipeline.reload.status
  end

  it "can run a real project" do
    project = real_project

    initial = FortCI::Pipeline.count
    post_as_user "/events", {project_id: project.id, name: 'test'}, real_user
    assert response.ok?
    assert_equal initial + 1, FortCI::Pipeline.count

    pipeline = FortCI::Pipeline.last

    assert_equal 'PENDING', pipeline.status

    initial = FortCI::Job.count
    FortCI::Worker.executor.run(1)
    assert_equal initial + 1, FortCI::Job.count
    assert_equal 'PENDING', pipeline.reload.status

    job = pipeline.jobs.first
    job.status = 'COMPLETED'
    job.save

    FortCI::Worker.executor.run(1)
    assert_equal 'SUCCESSFUL', pipeline.reload.status
  end

  it "does not pass an erroring pipeline" do
    project = real_project

    initial = FortCI::Pipeline.count
    post_as_user "/events", {project_id: project.id, name: 'errorjobtest'}, real_user
    assert response.ok?
    assert_equal initial + 2, FortCI::Pipeline.count

    pipeline = FortCI::Pipeline.last
    assert_equal 'PENDING', pipeline.status

    FortCI::Worker.executor.run(1)
    assert_equal 'ERROR', pipeline.reload.status

    FortCI::Worker.executor.run(1)
    assert_equal 'ERROR', pipeline.reload.status
  end
end
