require "test_helper"

describe FortCI::Event  do
  it "can execute" do
    initial = FortCI::Pipeline.count
    event = FortCI::Event.new(project_id: FortCI::Project.first.id, name: 'git::push')
    event.execute
    assert_equal initial + 1, FortCI::Pipeline.count
  end
end
