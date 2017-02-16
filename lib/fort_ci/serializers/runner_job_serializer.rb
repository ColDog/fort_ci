require "fort_ci/serializers/base_serializer"

module FortCI
  class RunnerJobSerializer < BaseSerializer
    attributes :id, :version, :repo, :build, :services, :commands

    def repo
      {
          name: object.project.name,
          commit: object.commit,
          provider: object.project.repo_provider,
          owner: object.project.repo_owner_name,
          token: object.project.auth_token,
      }
    end

  end
end
