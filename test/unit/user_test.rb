require "test_helper"

describe FortCI::User do
  it "can sync teams from a client" do
    user.sync
    assert user.teams.length > 0
  end

  it "can get all it's projects" do
    user.projects
  end
end
