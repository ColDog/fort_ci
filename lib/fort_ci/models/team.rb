require "fort_ci/db"
require "sequel"

module FortCI
  class Team < Sequel::Model
    one_to_many :projects
    many_to_many :users, left_key: :team_id, right_key: :user_id, join_table: :user_teams

    def client
      users.first.client
    end
  end
end
