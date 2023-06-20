defmodule ColorfulPandas.Repo.Migrations.AddOrganizations do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    create table(:organizations, prefix: "auth") do
      add :name, :string, null: false
      timestamps()
    end

    alter table(:identities, prefix: "auth") do
      add :organization_id, references(:organizations), null: false
    end
  end
end
