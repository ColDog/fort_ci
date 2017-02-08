require "test_helper"

describe FortCI::Controllers::Sessions do
  it "can sign up a user" do
    get "/auth/github"
    assert_equal 302, last_response.status
  end
end
