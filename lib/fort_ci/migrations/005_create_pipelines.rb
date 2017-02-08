Sequel.migration do
  change do
    create_table(:pipelines) do
      primary_key :id
      foreign_key :project_id, :projects, null: true
      String :definition
      String :stage
      String :status
      String :error,     text: true
      String :event,     text: true
      String :variables, text: true
    end
  end
end
