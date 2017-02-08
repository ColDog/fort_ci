require "test_helper"

describe FortCI::Controllers::Auth do
  it "can get a current user" do
    get "/users/current/", {}, 'rack.session' => { user_id: 1 }
    assert last_response.ok?, last_response.status
    puts response.body
  end
end
