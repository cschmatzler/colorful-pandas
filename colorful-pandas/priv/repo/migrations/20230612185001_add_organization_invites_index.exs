defmodule ColorfulPandas.Repo.Migrations.AddOrganizationInvites do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    create index(:organization_invites, :token, prefix: "auth", concurrently: true)
  end
end
