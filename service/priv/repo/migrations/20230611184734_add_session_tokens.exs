defmodule ColorfulPandas.Repo.Migrations.AddSessionTokens do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    create table(:session_tokens, prefix: "auth") do
      add :payload, :binary, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps(updated_at: false)
    end

    create index(:session_tokens, [:payload], prefix: "auth", concurrently: true)
  end
end
