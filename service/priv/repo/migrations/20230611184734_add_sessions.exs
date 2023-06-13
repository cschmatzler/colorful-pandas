defmodule ColorfulPandas.Repo.Migrations.AddSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, prefix: "auth") do
      add :token, :binary, null: false
      add :identity_id, references(:identities, on_delete: :delete_all), null: false
      timestamps(updated_at: false)
    end
  end
end
