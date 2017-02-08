Sequel.migration do
  change do
    create_table(:jobs) do
      String :id
      foreign_key :pipeline_id, :pipelines, null: false
      String :status
      String :commit
      String :branch
      String :worker
      String :spec, text: true
      
      primary_key :id
    end
  end
end
