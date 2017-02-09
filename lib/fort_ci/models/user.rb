require "fort_ci/db"
require "fort_ci/models/team"
require "fort_ci/models/project"
require "fort_ci/models/pipeline"
require "fort_ci/clients/github_client"
require "fort_ci/clients/mock_client"
require "sequel"

module FortCI
  class User < Sequel::Model
    many_to_many :teams, left_key: :user_id, right_key: :team_id, join_table: :user_teams
    one_to_many  :projects

    def self.from_omniauth(auth)
      new_user = false
      user = User.find(provider: auth.provider, provider_id: auth.uid)
      unless user
        user = create(provider: auth.provider, provider_id: auth.uid)
        new_user = true
      end

      user.username = auth.info.nickname
      user.email = auth.info.email
      user.name = auth.info.name
      user.token = auth.credentials.token
      user.refresh_token = auth.credentials.refresh_token
      user.save

      user.sync if new_user

      user
    end

    def sync
      client.teams.each do |team|
        team = Team.create(provider: provider, provider_id: team[:id], name: team[:name])
        DB[:user_teams].insert(user_id: id, team_id: team.id)
      end
    end

    def client
      @client ||= begin
        if provider == 'github'
          GithubClient.new(username, token)
        elsif provider == 'mock' && FortCI.config.env == :test
          MockClient.new(username, token)
        end
      end
    end
    
    def find_team!(pk)
      teams_dataset.with_pk!(pk)
    end

    def projects
      projects_dataset
    end

    def pipelines
      Pipeline
          .join(:projects, id: :project_id)
          .where('projects.user_id = ?', id)
          .select(Sequel.lit('pipelines.*'))
    end

    def jobs
      Job
          .join(:pipelines, id: :pipeline_id)
          .join(:projects, id: :project_id)
          .where('projects.user_id = ?', id)
          .select(Sequel.lit('jobs.*'))
    end

    def to_s
      "User(#{id})"
    end

  end
end
