defmodule ColorfulPandas.Repo.Migrations.AddIdentities do
  use Ecto.Migration

  # excellent_migrations:safety-assured-for-this-file raw_sql_executed
  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    execute "create extension if not exists citext", ""
    execute "create schema if not exists auth", ""

    role_create_query = "CREATE TYPE identities_role AS ENUM ('user', 'admin')"
    role_drop_query = "DROP TYPE identities_role"
    execute(role_create_query, role_drop_query)

    create table(:identities, prefix: "auth") do
      add :provider, :string, null: false
      add :uid, :string, null: false
      add :email, :string, null: false
      add :name, :string, null: false
      add :image_url, :string
      add :role, :identities_role
      timestamps()
    end

    create unique_index(:identities, [:provider, :uid], prefix: "auth", concurrently: true)
  end
end
