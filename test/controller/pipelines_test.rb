require "test_helper"

describe FortCI::PipelinesController do
  it "can get pipelines" do
    get_as_user "/pipelines/"
    assert response.ok?
  end
end
