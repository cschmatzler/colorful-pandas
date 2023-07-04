defmodule ColorfulPandas.Repo.Migrations.AddSignupFlows do
  use Ecto.Migration

  def change do
    create table(:signup_flows, prefix: "auth") do
      add :provider, :string, null: false
      add :uid, :string, null: false
      add :email, :string, null: false
      add :name, :string, null: true
      add :organization_name, :string, null: true
      add :invite_id, references(:organization_invites), null: true
      timestamps()
    end
  end
end
