require "fort_ci/db"
require "sequel"

module FortCI
  class Team < Sequel::Model
    one_to_many :projects
    many_to_many :users, left_key: :team_id, right_key: :user_id, join_table: :user_teams

    def client
      users.first.client
    end

    def pipelines
      Pipeline
          .join(:projects, id: :project_id)
          .where('projects.team_id = ?', id)
    end

    def jobs
      Job
          .join(:pipelines, id: :pipeline_id)
          .join(:projects, id: :project_id)
          .where('projects.team_id = ?', id)
    end

    def username
      name
    end

    def to_s
      "User(#{name})"
    end
  end
end
