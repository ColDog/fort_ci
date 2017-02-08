require "test_helper"

describe FortCI::User do
  it "can sync teams from github" do
    user.sync
    assert user.teams.length > 0
  end
end
