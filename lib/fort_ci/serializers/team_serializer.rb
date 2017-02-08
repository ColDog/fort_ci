require "fort_ci/serializers/base_serializer"

module FortCI
  class TeamSerializer < BaseSerializer
    attributes :id, :name
  end
end
