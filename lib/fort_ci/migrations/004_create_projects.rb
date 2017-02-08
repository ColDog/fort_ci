Sequel.migration do
  change do
    create_table(:projects) do
      primary_key :id
      foreign_key :user_id, :users, null: true
      foreign_key :team_id, :teams, null: true
      String :name
      String :repo_provider
      String :repo_id
      String :enabled_pipelines, text: true
      Boolean :enabled, default: false
    end
  end
end
