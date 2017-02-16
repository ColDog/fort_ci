require "fort_ci/serializers/base_serializer"

module FortCI
  class RunnerJobSerializer < BaseSerializer
    attributes :id, :repo, :build, :services, :commands

    def repo
      {
          name: object.project.name,
          branch: object.branch,
          commit: object.commit,
          provider: object.project.repo_provider,
          owner: object.project.repo_owner_name,
          token: object.project.auth_token,
          repo_url: object.project.repo_url,
      }
    end

    def build
      object.spec[:build]
    end

    def services
      object.spec[:services]
    end

    def commands
      object.spec[:commands]
    end

  end
end
