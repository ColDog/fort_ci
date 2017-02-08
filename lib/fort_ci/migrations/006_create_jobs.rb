Sequel.migration do
  change do
    create_table(:jobs) do
      String :id, primary_key: true
      foreign_key :pipeline_id, :pipelines, null: false
      String :status, null: false, default: 'QUEUED'
      String :commit
      String :branch
      String :runner
      String :spec, text: true
    end
  end
end
