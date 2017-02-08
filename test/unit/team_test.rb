require "test_helper"

describe FortCI::Team do
  it "can get team projects" do
    team.projects
  end

  it "can get team users" do
    assert team.users.length == 1
  end
end
