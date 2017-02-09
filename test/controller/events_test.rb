require "test_helper"

describe FortCI::EventsController do
  it "can create an event" do
    initial = FortCI::Pipeline.count
    post_as_user "/events", project_id: FortCI::Project.first.id, name: 'testevent'
    assert_equal initial + 2, FortCI::Pipeline.count
  end
end
