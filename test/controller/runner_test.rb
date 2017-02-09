describe FortCI::RunnerController do
  it "can pop some jobs" do
    get "/runner/pop", {},
        {'HTTP_AUTHORIZATION' => "Bearer #{worker_token}"}
    assert response.ok?, response.status
  end

  it "can pop a queued job" do
    sample_jobs
    get "/runner/pop", {},
        {'HTTP_AUTHORIZATION' => "Bearer #{worker_token}"}
    assert response.ok?, response.status
  end

  it "can update a job status" do
    sample_jobs
    get "/runner/pop", {},
        {'HTTP_AUTHORIZATION' => "Bearer #{worker_token}"}
    assert response.ok?, response.status

    job_id = response_json[:job][:id]

    post "/runner/job_status", {id: job_id, status: 'CANCELLED'},
        {'HTTP_AUTHORIZATION' => "Bearer #{worker_token}"}
    assert response.ok?, response.status
  end

  it "can reject a job" do
    sample_jobs
    get "/runner/pop", {},
        {'HTTP_AUTHORIZATION' => "Bearer #{worker_token}"}
    assert response.ok?, response.status

    job_id = response_json[:job][:id]

    post "/runner/reject", {id: job_id},
         {'HTTP_AUTHORIZATION' => "Bearer #{worker_token}"}
    assert response.ok?, response.status
  end

  def worker_token
    secret = FortCI.config.secret
    JWT.encode({runner: '1270.0.0.1:3001'}, secret)
  end

  def sample_jobs
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
