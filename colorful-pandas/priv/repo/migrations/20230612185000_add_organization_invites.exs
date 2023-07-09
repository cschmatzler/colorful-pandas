defmodule ColorfulPandas.Repo.Migrations.AddOrganizationInvites do
  use Ecto.Migration

  def change do
    create table(:organization_invites, prefix: "auth") do
      add :token, :binary, null: false
      add :organization_id, references(:organizations), null: false
      add :created_by_id, references(:identities), null: false
      add :accepted_at, :utc_datetime, null: true
      timestamps(updated_at: false)
    end
  end
end
