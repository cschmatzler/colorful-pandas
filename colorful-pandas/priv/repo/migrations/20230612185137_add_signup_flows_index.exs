defmodule ColorfulPandas.Repo.Migrations.AddSignupFlowsIndex do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    create unique_index(:signup_flows, [:provider, :uid], prefix: "auth", concurrently: true)
  end
end
