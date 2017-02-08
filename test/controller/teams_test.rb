require "test_helper"

describe FortCI::TeamsController do
  it "can get this users teams" do
    get_as_user "/teams/"
    assert last_response.ok?, last_response.status
  end

  it "can get a single team" do
    get_as_user "/teams/#{team.id}"
    assert last_response.ok?, last_response.status
  end

  it "can get users from a team" do
    get_as_user "/teams/#{team.id}/users"
    assert last_response.ok?, last_response.status
  end
end
