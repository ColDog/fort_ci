describe FortCI do
  it "can queue jobs" do
    project = FortCI::Project.first

    post_as_user "/events", {project_id: project.id, name: 'test'}
    assert response.ok?

    FortCI::Worker.executor.run(1)

  end
end
