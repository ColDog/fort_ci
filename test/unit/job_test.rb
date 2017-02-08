describe FortCI::Job do
  it "can be created" do
    pipeline = FortCI::Pipeline.create(
        project: user.projects.first,
        variables: {name: 'testing'},
        definition: 'BasicPipeline',
        stage: nil,
        status: 'PENDING',
        event: {project_id: user.projects.first.id},
    )

    FortCI::Job.create(
        id: 'test-job-1',
        pipeline_id: pipeline.id,
        pipeline_stage: 'test',
        commit: '1230001112',
        branch: 'test/123',
        runner: nil,
        spec: {
            name: 'testig',
        },
    )
  end
end
