defmodule ColorfulPandas.Repo.Migrations.AddOrganizationInvites do
  use Ecto.Migration

  def change do
    create table(:organization_invites, prefix: "auth") do
      add :token, :binary, null: false
      add :created_by_id, references(:identities), null: false
      add :organization_id, references(:organizations), null: false
      timestamps()
    end
  end
end
