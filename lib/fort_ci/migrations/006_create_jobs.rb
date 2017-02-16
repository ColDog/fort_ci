Sequel.migration do
  change do
    create_table(:jobs) do
      String :id, primary_key: true
      foreign_key :pipeline_id, :pipelines, null: false
      foreign_key :project_id, :projects, null: true
      String :pipeline_stage, index: true
      String :status, null: false, default: 'QUEUED'
      String :commit
      String :branch
      String :runner
      String :output_url
      String :version
      String :build, text: true
      String :services, text: true
      String :commands, text: true
    end
  end
end
