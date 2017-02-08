require "fort_ci/serializers/base_serializer"

module FortCI
  class ProjectSerializer < BaseSerializer
    attributes :id, :user_id, :team_id, :name, :repo_provider, :repo_name,
               :repo_id, :enabled_pipelines, :enabled
  end
end
