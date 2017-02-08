require "test_helper"

describe FortCI::UsersController do
  it "can get a current user" do
    get_as_user "/users/current/"
    assert last_response.ok?, last_response.status
  end

  it "can get this users teams" do
    user.sync
    get_as_user "/teams/"
    assert last_response.ok?, last_response.status
  end
end
