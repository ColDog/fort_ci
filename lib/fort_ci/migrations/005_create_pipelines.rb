Sequel.migration do
  change do
    create_table(:pipelines) do
      primary_key :id
      foreign_key :project_id, :projects, null: true
      String :definition_class
      String :variables, text: true
      String :stage
      String :status
      String :error, text: true
      String :event, text: true
    end
  end
end
