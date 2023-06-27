defmodule ColorfulPandas.Repo.Migrations.AddIdentitiesIndex do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    create unique_index(:identities, [:provider, :uid], prefix: "auth", concurrently: true)
  end
end
