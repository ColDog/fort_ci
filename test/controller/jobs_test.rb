require "test_helper"

describe FortCI::JobsController do
  it "can get jobs" do
    get_as_user "/jobs/"
    assert response.ok?
  end
end
