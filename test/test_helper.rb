ENV["RACK_ENV"] = "test"

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "fort_ci"

require "minitest/autorun"
require "minitest/spec"
require "minitest/reporters"
require "rack/test"

reporter_options = {color: true}
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

require "omniauth"

OmniAuth.config.test_mode = true

test_auth = OmniAuth::AuthHash.new(
    provider: 'mock',
    uid: '12345',
    info: {
        email: 'test123',
        username: 'testing',
        name: '1234',
    },
    credentials: {},
)
OmniAuth.config.mock_auth[:github] = test_auth

require "test_seeder"
require "fort_ci/helpers/serialization_helper"

class Minitest::Spec
  include Rack::Test::Methods

  def run(*args, &block)
    Sequel::Model.db.transaction(:rollback=>:always, :auto_savepoint=>true){super}
  end

  def app
    FortCI::App
  end

  include FortCI::SerializationHelper

  def user
    @test_user ||= FortCI::User.find(email: 'colinwalker270@gmail.com')
  end

  def team
    @test_team ||= FortCI::Team.find(name: 'TestTeam')
  end

  def get_as_user(path, opts={}, target_user=user)
    get path, opts, 'rack.session' => {user_id: target_user.id}
  end

  def post_as_user(path, opts={}, target_user=user)
    post path, opts, 'rack.session' => {user_id: target_user.id}
  end

  def patch_as_user(path, opts={}, target_user=user)
    patch path, opts, 'rack.session' => {user_id: target_user.id}
  end

  def response
    last_response
  end

  def response_json
    symbolize_keys(JSON.parse(last_response.body))
  end
end
