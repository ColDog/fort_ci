require "test_helper"

describe FortCI::UsersController do
  it "can get a current user" do
    get_as_user "/users/current/"
    assert last_response.ok?, last_response.status
  end
end
