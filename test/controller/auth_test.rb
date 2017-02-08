require "test_helper"

describe FortCI::Controllers::Auth do
  it "can sign up a user" do
    get "/auth/github"
    assert_equal 302, last_response.status
    follow_redirect!
    assert_equal 302, last_response.status
  end

  it "can log out a user" do
    delete "/auth"
    assert last_response.ok?
  end
end
