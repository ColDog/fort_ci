require "fort_ci/serializers/base"

module FortCI
  class UserSerializer < BaseSerializer
    root_key :user
    attributes :id, :name, :email
  end
end
