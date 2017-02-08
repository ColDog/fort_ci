Sequel.migration do
  change do
    create_table(:user_teams) do
      foreign_key :user_id, :users
      foreign_key :team_id, :teams
      primary_key [:user_id, :team_id]
    end
  end
end
