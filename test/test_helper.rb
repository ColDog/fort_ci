ENV["RACK_ENV"] = "test"

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "fort_ci"

require "minitest/autorun"
require "minitest/spec"
require "rack/test"

require "omniauth"

OmniAuth.config.test_mode = true

test_auth = OmniAuth::AuthHash.new(
    provider: 'github',
    uid: '12345',
    info: {
        email: 'test123',
        username: 'testing',
        name: '1234',
    },
    credentials: {},
)
OmniAuth.config.mock_auth[:github] = test_auth

include Rack::Test::Methods

def app
  FortCI::App
end

class Minitest::Spec
  def run(*args, &block)
    Sequel::Model.db.transaction(:rollback=>:always, :auto_savepoint=>true){super}
  end
end
