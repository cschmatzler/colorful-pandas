defmodule ColorfulPandas.Repo.Migrations.AddIdentities do
  use Ecto.Migration

  def change do
    role_create_query = "CREATE TYPE identities_role AS ENUM ('user', 'admin')"
    role_drop_query = "DROP TYPE identities_role"
    execute(role_create_query, role_drop_query)

    create table(:identities, prefix: "auth") do
      add :provider, :string, null: false
      add :uid, :string, null: false
      add :email, :string, null: false
      add :name, :string, null: false
      add :image_url, :string
      add :role, :identities_role
      timestamps()
    end
  end
end
