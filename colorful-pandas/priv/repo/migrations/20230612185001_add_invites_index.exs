defmodule ColorfulPandas.Repo.Migrations.AddInvitesIndex do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    create index(:invites, :token, prefix: "auth", concurrently: true)
  end
end
