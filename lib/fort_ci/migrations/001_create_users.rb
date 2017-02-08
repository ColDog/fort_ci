Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :name
      String :username
      String :email
      String :provider,    null: false
      String :provider_id, null: false, index: true
      String :token
      String :refresh_token
    end
  end
end
