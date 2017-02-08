Sequel.migration do
  change do
    create_table(:worker_jobs) do
      primary_key :id
      Time     :locked_at,  null: true
      Time     :run_at,     null: true
      String   :locked_by,  null: true
      String   :handler,    null: false, text: true
      String   :last_error, null: true,  text: true
      String   :queue,      null: false, default: 'default'
      String   :job_class,  null: false
      Integer  :attempts,   null: false, default: 0
      Integer  :priority,   null: false, default: 0
    end
  end
end
