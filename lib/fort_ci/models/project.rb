require "fort_ci/db"
require "fort_ci/models/user"
require "fort_ci/models/team"
require "sequel"

module FortCI
  class Project < Sequel::Model
    attr_accessor :repo_owner_id
    many_to_one :team
    many_to_one :user

    def self.create_for_entity(entity, name)
      found = find(name: name)
      return found if found

      repo = entity.client.repo(name)
      project = new({
          name: name,
          repo_provider: user.provider,
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

  end
end
