Sequel.migration do
  change do
    create_table(:teams) do
      primary_key :id
      String :name
      String :provider,    null: false
      String :provider_id, null: false, index: true
    end
  end
end
