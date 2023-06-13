defmodule ColorfulPandas.Repo.Migrations.AddSessionsIndex do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    create index(:sessions, [:token], prefix: "auth", concurrently: true)
  end
end
