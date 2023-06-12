defmodule ColorfulPandas.Repo.Migrations.AddAuthSchema do
  use Ecto.Migration

  # excellent_migrations:safety-assured-for-this-file raw_sql_executed
  def change do
    execute "create schema if not exists auth", "drop schema auth"
  end
end
