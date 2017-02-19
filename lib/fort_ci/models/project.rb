require "fort_ci/db"
require "fort_ci/models/user"
require "fort_ci/models/team"
require "sequel"

module FortCI
  class Project < Sequel::Model
    plugin :serialization

    attr_accessor :repo_owner_id
    many_to_one :team
    many_to_one :user
    serialize_attributes :json, :enabled_pipelines

    def self.create_for_entity(entity, name)
      found = find(name: name)
      return found if found

      repo = entity.client.repo(name)
      project = new({
          name: name,
          repo_provider: entity.provider,
          repo_id: repo[:id],
          repo_owner_id: repo[:owner_id],
          enabled: true,
      })

      if repo[:owner_type] == :user
        if entity.is_a?(User)
          project.user = entity
        elsif entity.is_a?(Team)
          project.user = entity.users_dataset.find(provider_id: repo[:owner_id]).first
        end
      elsif repo[:owner_type] == :team
        if entity.is_a?(User)
          project.team = entity.teams_dataset.find(provider_id: repo[:owner_id]).first
        elsif entity.is_a?(Team)
          project.team = entity
        end
      else
        raise("Invalid owner type #{repo[:owner_type]}")
      end

      project.save
    end

    def validate
      super

      errors.add(:owner, 'cannot be null') if team_id.nil? && user_id.nil?

      if team && team.provider_id.to_s != repo_owner_id.to_s
        errors.add(:team, 'is not authorized')
      end

      if user && user.provider_id.to_s != repo_owner_id.to_s
        errors.add(:user, 'is not authorized')
      end
    end

    def after_create
      super
      # owner.client.register_webhooks(name)
    end

    def after_destroy
      super
      # owner.client.remove_webhooks(name)
    end

    def owner
      user || team
    end

    def branches
      owner.client.branches(name)
    end

    def repo_owner_name
      owner.username
    end

    def auth_token
      if user
        user.token
      elsif team
        team.users.first.token
      end
    end

    def repo_url
      if repo_provider == 'github'
        "https://#{auth_token}@github.com/#{repo_owner_name}/#{name}.git"
      end
    end

    def to_s
      "Project(#{name})"
    end

  end
end
