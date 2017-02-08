require "fort_ci/serializers/base_serializer"

module FortCI
  class UserSerializer < BaseSerializer
    attributes :id, :name, :email
  end
end
