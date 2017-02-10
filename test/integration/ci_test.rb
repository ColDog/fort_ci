require "test_helper"

describe FortCI do
  it "can perform and queue jobs" do
    project = FortCI::Project.first

    initial = FortCI::Pipeline.count
    post_as_user "/events", {project_id: project.id, name: 'test'}
    assert response.ok?
    assert_equal initial + 1, FortCI::Pipeline.count

    pipeline = FortCI::Pipeline.last

    assert_equal 'PENDING', pipeline.status
  end

  it "can run a pipeline" do
    project = FortCI::Project.first

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
end
