Sequel.migration do
  change do
    create_table(:jobs) do
      String :id, primary_key: true
      foreign_key :pipeline_id, :pipelines, null: false
      String :status
      String :commit
      String :branch
      String :worker
      String :spec, text: true
    end
  end
end
