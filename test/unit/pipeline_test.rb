require "test_helper"

describe FortCI::Pipeline do
  it "can create a pipeline" do
    pipeline = FortCI::Pipeline.create(
        project: user.projects.first,
        variables: {name: 'testing'},
        definition: 'BasicPipeline',
        stage: nil,
        status: 'PENDING',
        event: {project_id: user.projects.first.id},
    )

    pipeline = FortCI::Pipeline.find(id: pipeline.id)
    assert pipeline.event.is_a?(FortCI::Event)
  end
end
