defmodule ColorfulPandas.Repo.Migrations.Init do
  use Ecto.Migration

  # excellent_migrations:safety-assured-for-this-file raw_sql_executed
  def change do
    execute "create extension if not exists citext", "drop extension citext"
  end
end
